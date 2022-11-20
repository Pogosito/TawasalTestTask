//
//  
//  SearchRepositoriesPresenter.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 25.10.2022.
//
//

import AsyncDisplayKit

@MainActor
protocol SearchRepositoriesPresenterProtocol: AnyObject {

	func present(repositories: [GitHubRepositoryItem], isNeedInsert: Bool)

	func presentFirstReadmeImage(by url: URL, repositoryId: Int)

	func presentTextInSearchController(_ text: String)

	func hideActivityIndicator()

	func hideFooterActivityIndicator()
}

final class SearchRepositoriesPresenter {

	weak var viewController: SearchRepositoriesViewControllerProtocol?
}

// MARK: - SearchRepositoriesPresenterProtocol

extension SearchRepositoriesPresenter: SearchRepositoriesPresenterProtocol {

	func present(repositories: [GitHubRepositoryItem], isNeedInsert: Bool) {
		var repositoriesNodesModels: [RepositoryNodeItem] = []

		repositories.forEach { repository in
			let repositoryNodeModel = RepositoryNodeItem(repositoryId: repository.id,
														 avatarUrl: repository.owner?.avatarUrl,
														 userLogin: repository.owner?.login,
														 repositoryName: repository.name,
														 description: repository.descriptionField,
														 stars: repository.stargazersCount,
														language: repository.language)
			repositoriesNodesModels.append(repositoryNodeModel)
		}
		isNeedInsert
		? viewController?.insert(newRepositories: repositoriesNodesModels)
		: viewController?.reloadTable(with: repositoriesNodesModels)
	}

	func presentFirstReadmeImage(by url: URL, repositoryId: Int) {
		viewController?.setFirstReadmeImage(by: url, for: repositoryId)
	}

	func presentTextInSearchController(_ text: String) {
		viewController?.setSearchController(text: text)
	}

	func hideActivityIndicator() {
		viewController?.hideActivityIndicator()
	}

	func hideFooterActivityIndicator() {
		viewController?.hideFooterActivityIndicator()
	}
}
