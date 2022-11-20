//
//  
//  SearchRepositoriesRouter.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 25.10.2022.
//
//

import AsyncDisplayKit

@MainActor
protocol SearchRepositoriesRouterProtocol {

	func presetEmptyResultAlert()

	func moveToDetailedInformation(about repository: GitHubRepositoryItem)
}

final class SearchRepositoriesRouter {

	weak var viewController: (ASDKViewController<ASTableNode>
							  & SearchRepositoriesViewControllerProtocol)?
}

// MARK: - SearchRepositoriesRouterProtocol

extension SearchRepositoriesRouter: SearchRepositoriesRouterProtocol {

	func presetEmptyResultAlert() {
		let alert = UIAlertController(title: Strings.emptyResultTitle,
									  message: Strings.emptyResultMessage,
									  preferredStyle: .alert)
		alert.addAction(.init(title: Strings.ok, style: .default))
		viewController?.present(alert, animated: true)
	}

	func moveToDetailedInformation(about repository: GitHubRepositoryItem) {
		let repositoryDetailedInformationVC = RepositoryDetailedInformationVC(repositoryModel: repository)
		viewController?.navigationController?.pushViewController(repositoryDetailedInformationVC, animated: true)
	}
}
