//
//  
//  SearchRepositoriesInteractor.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 25.10.2022.
//
//

import AsyncDisplayKit
import Foundation

protocol SearchRepositoriesInteractorProtocol {

	func getRepositories(by name: String, context: ASBatchContext?)

	func extractReadme(repositoryId: Int, ownerName: String, repositoryName: String)

	func processTap(on repository: RepositoryNodeItem)

	func logout()
}

final class SearchRepositoriesInteractor {

	var pageCounter = 1
	var totalPages = -1
	var wasLastShowedRepositoriesCached = false

	// MARK: - Private properties

	private let presenter: SearchRepositoriesPresenterProtocol
	private let router: SearchRepositoriesRouterProtocol
	private let gitHubSearchRepositoriesService: RepositoriesSearchable
	private let logoutFlowCoordinator: LogoutFlowCoordinatorProtocol
	private let alertsHandler: AlertsHandlerProtocols
	private let repositoriesCacheService: Cacheable
	private let readmeExtractor: ReadmeExtractable

	private var lastShowedRepositories: [GitHubRepositoryItem] = []
	private(set) var lastSearchedName: String = "Texture"

	// MARK: - Init

	init(presenter: SearchRepositoriesPresenterProtocol,
		 router: SearchRepositoriesRouterProtocol,
		 gitHubSearchRepositoriesService: RepositoriesSearchable,
		 logoutFlowCoordinator: LogoutFlowCoordinatorProtocol,
		 alertsHandler: AlertsHandlerProtocols,
		 repositoriesCacheService: Cacheable,
		 readmeExtractor: ReadmeExtractable) {
		self.presenter = presenter
		self.router = router
		self.gitHubSearchRepositoriesService = gitHubSearchRepositoriesService
		self.logoutFlowCoordinator = logoutFlowCoordinator
		self.alertsHandler = alertsHandler
		self.repositoriesCacheService = repositoriesCacheService
		self.readmeExtractor = readmeExtractor
		NotificationCenter.default.addObserver(self,
											   selector: #selector(appMovedToBackground),
											   name: UIApplication.willResignActiveNotification, object: nil)
	}
}

// MARK: - SearchRepositoriesInteractorProtocol

extension SearchRepositoriesInteractor: SearchRepositoriesInteractorProtocol {

	func getRepositories(by name: String, context: ASBatchContext?) {

		lastSearchedName = name == "" ? "Texture" : name
		let isFromSearch = context == nil
		let isInitialRequest = self.totalPages == -1

		Task {
			if await self.presentRepositoriesFromCacheIfNeeded(!isFromSearch, isInitialRequest) {
				context?.completeBatchFetching(true)
				return
			}

			if await self.updatePageCounterAndCheckIsLastPage(isFromSearch, isInitialRequest) {
				context?.completeBatchFetching(true)
				return
			}

			do {
				let searchedRepositories = try await self.gitHubSearchRepositoriesService.searchRepositories(
					by: lastSearchedName,
					page: self.pageCounter,
					by: URLs.searchReposURLString
				)
				await self.updatePageTotalCountIfNeeded(searchedRepositories.totalCount, isFromSearch, isInitialRequest)
				if await self.presentAlertAboutEmptySearchIfNeeded(
					repositoriesCount: searchedRepositories.totalCount ?? 0,
					isFromSearch) { return }
				await self.presentOrInsert(repositories: searchedRepositories.items, isFromSearch)
				self.wasLastShowedRepositoriesCached = false
				context?.completeBatchFetching(true)
			} catch let error {
				context?.cancelBatchFetching()
				await self.process(error: error)
			}
		}
	}
}

@MainActor
extension SearchRepositoriesInteractor {
	func extractReadme(repositoryId: Int, ownerName: String, repositoryName: String) {
		if let currentRepository = lastShowedRepositories.first(where: { repositoryModel in repositoryModel.id == repositoryId }),
		   let safeImageURL = currentRepository.firstImageURLInReadme {
			self.presenter.presentFirstReadmeImage(by: safeImageURL, repositoryId: repositoryId)
		} else {
			Task.detached {
				guard let safeReadme = await self.readmeExtractor.extractReadme(dataForGettingReadme: (ownerName, repositoryName),
																				by: URLs.baseGitHubURLString),
					  let safeReadmeUrl = URL(string: safeReadme.downloadUrl),
					  let readmeData = try? Data(contentsOf: safeReadmeUrl) else {
					return
				}
				let readmeString = String(data: readmeData, encoding: .utf8)
				guard let firstImageUrl = readmeString?.getFirstImageUrlByMarkdownPattern() else {
					return
				}
				var currentRepository = self.lastShowedRepositories.first { repositoryModel in repositoryModel.id == repositoryId }
				currentRepository?.firstImageURLInReadme = firstImageUrl
				await self.presenter.presentFirstReadmeImage(by: firstImageUrl, repositoryId: repositoryId)
			}
		}
	}

	func processTap(on repository: RepositoryNodeItem) {
		guard let fullRepositoryModel = lastShowedRepositories.first(where: { model in model.id == repository.repositoryId }) else { return }
		router.moveToDetailedInformation(about: fullRepositoryModel)
	}

	func logout() {
		repositoriesCacheService.clearCache()
		logoutFlowCoordinator.logout()
	}
}

@MainActor
private extension SearchRepositoriesInteractor {

	func presentRepositoriesFromCacheIfNeeded(_ isNotFromSearch: Bool, _ isInitialRequest: Bool) -> Bool {
		if isNotFromSearch && isInitialRequest {
			let searchedInformationFromCache: (repositories: [GitHubRepositoryItem], name: String?,
											   totalPages: Int, page: Int)? = repositoriesCacheService.readRepositoriesSearchInformation()
			if let searchedInformationFromCache = searchedInformationFromCache, !searchedInformationFromCache.repositories.isEmpty {
				lastShowedRepositories = searchedInformationFromCache.repositories
				lastSearchedName = searchedInformationFromCache.name ?? ""
				pageCounter = searchedInformationFromCache.page
				totalPages = searchedInformationFromCache.totalPages
				presenter.presentTextInSearchController(lastSearchedName)
				presenter.present(repositories: lastShowedRepositories, isNeedInsert: false)
				return true
			}
		}
		return false
	}

	func updatePageCounterAndCheckIsLastPage(_ isFromSearch: Bool, _ isInitialRequest: Bool) -> Bool {
		if isFromSearch {
			pageCounter = 1
		} else if !isInitialRequest {
			pageCounter += 1
			print("<TALog: Search repos log> get next page: \(pageCounter)")
			if pageCounter >= totalPages {
				pageCounter = totalPages
				presenter.hideFooterActivityIndicator()
				print("<TALog: Search repos log> you on the last page: \(totalPages)")
				return true
			}
		}
		return false
	}

	func updatePageTotalCountIfNeeded(_ searchedRepositoriesTotalCount: Int?, _ isFromSearch: Bool, _ isInitialRequest: Bool) {
		if let safeSearchedReposTotalCount = searchedRepositoriesTotalCount, isFromSearch || isInitialRequest {
			totalPages = Int((Float(safeSearchedReposTotalCount) / 100.0).rounded(.up))
			print(
				"<TALog: Search repos log> Find repositories | name: \(lastSearchedName) | total: \(safeSearchedReposTotalCount) | number of pages: \(totalPages)"
			)
		}
	}

	func presentAlertAboutEmptySearchIfNeeded(repositoriesCount: Int, _ isFromSearch: Bool) -> Bool {
		if isFromSearch {
			presenter.hideActivityIndicator()
			if repositoriesCount == 0 {
				router.presetEmptyResultAlert()
				return true
			}
		}
		return false
	}

	func presentOrInsert(repositories items: [GitHubRepositoryItem], _ isFromSearch: Bool) {
		lastShowedRepositories = isFromSearch ? items : lastShowedRepositories + items
		presenter.present(repositories: items, isNeedInsert: !isFromSearch)
	}

	func process(error: Error) {
		presenter.hideActivityIndicator()
		alertsHandler.showErrorAlertWithOkButton(error)
	}

	@objc func appMovedToBackground() {
		if !wasLastShowedRepositoriesCached {
			repositoriesCacheService.writeRepositoriesSearchInformation(repositories: lastShowedRepositories,
																 name: lastSearchedName, totalPages: totalPages,
																 page: pageCounter)
			wasLastShowedRepositoriesCached = true
		}
	}
}
