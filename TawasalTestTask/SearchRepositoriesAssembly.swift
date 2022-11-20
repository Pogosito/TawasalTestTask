//
//  
//  SearchRepositoriesAssembly.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 25.10.2022.
//
//

import AsyncDisplayKit

final class SearchRepositoriesAssembly {

	static func build(logoutFlowCoordinator: LogoutFlowCoordinatorProtocol) -> ASDKViewController<ASTableNode> {

		let viewController = SearchRepositoriesViewController()
		let presenter = SearchRepositoriesPresenter()
		let router = SearchRepositoriesRouter()
		let networkClient = NetworkClient(urlSession: URLSession.shared)
		let gitHubSearchRepositoriesService = GitHubSearchRepositoriesService(networkClient: networkClient)
		let alertHandler = AlertsHandler(currentController: viewController)
		let repositoriesCache = GitHubRepositoriesCacheService()
		let readmeExtractor = GitHubExtractReadmeService(networkClient: networkClient)

		let interactor = SearchRepositoriesInteractor(presenter: presenter,
													  router: router,
													  gitHubSearchRepositoriesService: gitHubSearchRepositoriesService,
													  logoutFlowCoordinator: logoutFlowCoordinator,
													  alertsHandler: alertHandler,
													  repositoriesCacheService: repositoriesCache,
													  readmeExtractor: readmeExtractor)

		viewController.interactor = interactor
		presenter.viewController = viewController
		router.viewController = viewController

		return viewController
	}

	private init() {}
}
