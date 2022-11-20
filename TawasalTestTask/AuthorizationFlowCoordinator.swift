//
//  AuthorizationFlowCoordinator.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 23.10.2022.
//

import AsyncDisplayKit

final class AuthorizationFlowCoordinator {

	// MARK: - Private properties

	private let navigationController: ASDKNavigationController
	private let authorizationMetadataInteractor: AuthorizationMetadataInteractionProtocol

	// MARK: - Init

	init(navigationController: ASDKNavigationController,
		 authorizationMetadataInteractor: AuthorizationMetadataInteractionProtocol) {
		self.navigationController = navigationController
		self.authorizationMetadataInteractor = authorizationMetadataInteractor
	}
}

// MARK: - AuthorizationFlowCoordinatorProtocol

extension AuthorizationFlowCoordinator: StartAuthorizationFlowCoordinatorProtocol {

	func startAuthorizationIfNeeded() -> ASDKNavigationController {
		let authorizationController = AuthorizationAssembly.build(loginFlowCoordinator: self)
		navigationController.viewControllers = authorizationMetadataInteractor.isTheUserAuthorized()
		? [authorizationController, SearchRepositoriesAssembly.build(logoutFlowCoordinator: self)]
		: [authorizationController]
		return navigationController
	}
}

// MARK: - LoginFlowCoordinatorProtocol

extension AuthorizationFlowCoordinator: LoginFlowCoordinatorProtocol {

	func login() {
		authorizationMetadataInteractor.setUserAuthorization(status: true)
		let searchRepositoriesViewController = SearchRepositoriesAssembly.build(logoutFlowCoordinator: self)

		navigationController.pushViewController(searchRepositoriesViewController,
												animated: true)
	}
}

// MARK: - LogoutFlowCoordinatorProtocol

extension AuthorizationFlowCoordinator: LogoutFlowCoordinatorProtocol {

	func logout() {
		authorizationMetadataInteractor.setUserAuthorization(status: false)
		navigationController.popViewController(animated: true)
	}
}
