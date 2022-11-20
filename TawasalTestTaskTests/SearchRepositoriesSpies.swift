//
//  SearchRepositoriesSpies.swift
//  TawasalTestTaskTests
//
//  Created by Pogos Anesyan on 05.11.2022.
//

@testable import TawasalTestTask
import AsyncDisplayKit

// MARK: - Interactor

final class SearchRepositoriesInteractorSpy: SearchRepositoriesInteractorProtocol {

	private(set) var searchRepositoriesDidCall = false
	private(set) var logoutDidCall = false
	private(set) var extractReadmeDidCall = false
	private(set) var processTapDidCall = false

	func getRepositories(by name: String, context: ASBatchContext?) {
		searchRepositoriesDidCall = true
	}

	func extractReadme(repositoryId: Int, ownerName: String, repositoryName: String) {
		extractReadmeDidCall = true
	}
	
	func processTap(on repository: RepositoryNodeItem) {
		processTapDidCall = true
	}

	func logout() {
		logoutDidCall = true
	}
}

// MARK: - Presenter

final class SearchRepositoriesPresenterSpy: SearchRepositoriesPresenterProtocol {

	private(set) var wasRepositoriesInserted = false
	private(set) var presentRepositoriesDidCall = false
	private(set) var presentFirstReadmeImageDidCall = false
	private(set) var presentTextInSearchControllerDidCall = false
	private(set) var hideActivityIndicatorDidCall = false
	private(set) var hideFooterActivityIndicatorDidCall = false

	func present(repositories: [GitHubRepositoryItem], isNeedInsert: Bool) {
		wasRepositoriesInserted = isNeedInsert
		presentRepositoriesDidCall = true
	}
	
	func presentFirstReadmeImage(by url: URL, repositoryId: Int) {
		presentFirstReadmeImageDidCall = true
	}
	
	func presentTextInSearchController(_ text: String) {
		presentTextInSearchControllerDidCall = true
	}
	
	func hideActivityIndicator() {
		hideActivityIndicatorDidCall = true
	}
	
	func hideFooterActivityIndicator() {
		hideFooterActivityIndicatorDidCall = true
	}
}

// MARK: - Router

final class SearchRepositoriesRouterSpy: SearchRepositoriesRouterProtocol {

	private(set) var presentEmptyResultAlertDidCall = false
	private(set) var moveToDetailedInformationDidCall = false

	func presetEmptyResultAlert() {
		presentEmptyResultAlertDidCall = true
	}

	func moveToDetailedInformation(about repository: GitHubRepositoryItem) {
		moveToDetailedInformationDidCall = true
	}
}

// MARK: - RepositoriesSearchable

final class GitHubSearchRepositoriesServiceSpy: RepositoriesSearchable {

	var response = SearchRepositoriesResponse(incompleteResults: true,
											  items: [], totalCount: 10)
	var errorBeingThrown: GitHubServicesErrors?

	private(set) var searchRepositoriesDidCall = false

	init(networkClient: Networkable) {}
	
	func searchRepositories(by name: String,
							page: Int,
							by urlString: String) async throws -> SearchRepositoriesResponse {
		if let errorBeingThrown = errorBeingThrown { throw errorBeingThrown }
		searchRepositoriesDidCall = true
		return response
	}
}

// MARK: - ASTableNode

final class ASTableNodeSpy: ASTableNode {

	private(set) var insertRowsDidCall = false

	override func insertRows(at indexPaths: [IndexPath],
							 with animation: UITableView.RowAnimation) {
		insertRowsDidCall = true
	}
}

// MARK: - GitHubRepositoriesCacheServiceSpy

final class GitHubRepositoriesCacheServiceSpy: Cacheable {

	var repositoriesJSON: String? = "[{}]"

	private(set) var writeRepositoriesSearchInformationDidCall = false
	private(set) var readRepositoriesSearchInformationDidCall = false
	private(set) var clearCacheDidCall = false
	private(set) var writeRepositoriesSearchInformationCallCount = 0

	func writeRepositoriesSearchInformation<RepositoryModel: Codable>(repositories: RepositoryModel,
																	  name: String, totalPages: Int,
																	  page: Int) {
		writeRepositoriesSearchInformationCallCount += 1
		writeRepositoriesSearchInformationDidCall = true
	}
	
	func readRepositoriesSearchInformation<RepositoryModel: Codable>() -> (repositories: RepositoryModel, name: String?,
																		   totalPages: Int, page: Int)? {
		if let safeRepositoriesJSON = repositoriesJSON {
			readRepositoriesSearchInformationDidCall = true
			let data = safeRepositoriesJSON.data(using: .utf8)!
			return (try! JSONDecoder().decode(RepositoryModel.self, from: data), "Pogos", 10, 1)
		} else {
			return nil
		}
	}
	
	func clearCache() {
		clearCacheDidCall = true
	}
}

// MARK: - GitHubExtractReadmeServiceSpy

final class GitHubExtractReadmeServiceSpy: ReadmeExtractable {

	var gitHubReadmeModel = GitHubReadmeModel(downloadUrl: "")

	private(set) var extractReadmeDidCall = false

	init(networkClient: Networkable) {}

	func extractReadme(dataForGettingReadme: (ownerName: String, repositoryName: String), by urlString: String) async -> GitHubReadmeModel? {
		extractReadmeDidCall = true
		return gitHubReadmeModel
	}
}

// MARK: - ASBatchContextSpy

final class ASBatchContextSpy: ASBatchContext {

	private(set) var completeBatchFetchingDidCall = false
	private(set) var didCompleteFetching = false
	private(set) var cancelBatchFetchingDidCall = false

	override func completeBatchFetching(_ didComplete: Bool) {
		self.didCompleteFetching = didComplete
		completeBatchFetchingDidCall = true
	}

	override func cancelBatchFetching() {
		cancelBatchFetchingDidCall = true
	}
}
