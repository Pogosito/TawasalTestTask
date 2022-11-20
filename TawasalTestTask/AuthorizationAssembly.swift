//
//  AuthorizationAssembly.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 23.10.2022.
//

import AsyncDisplayKit

final class AuthorizationAssembly {

	static func build(loginFlowCoordinator: LoginFlowCoordinatorProtocol) -> ASDKViewController<ASDisplayNode> {

		let viewController = AuthorizationViewController()

		let networkClient = NetworkClient(urlSession: URLSession.shared)

		let gitHubAuthenticationService = GitHubAuthenticationService(networkClient: networkClient)
		let alertHandler = AlertsHandler(currentController: viewController)

		let interactor = AuthorizationInteractor(viewController: viewController,
												 gitHubAuthenticationService: gitHubAuthenticationService,
												 loginFlowCoordinator: loginFlowCoordinator,
												 alertsHandler: alertHandler)
		viewController.interactor = interactor

		return viewController
	}

	private init() {}
}
