//
//  AuthorizationInteractor.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 23.10.2022.
//

import Foundation
import AuthenticationServices

protocol AuthorizationInteractorProtocol {

	func startAuthorization(with token: String)
}

final class AuthorizationInteractor {

	// MARK: - Private properties

	private weak var viewController: AuthorizationViewControllerProtocol?
	private let gitHubAuthenticationService: Authenticable
	private var loginFlowCoordinator: LoginFlowCoordinatorProtocol?
	private var alertsHandler: AlertsHandlerProtocols

	// MARK: - Init

	init(viewController: AuthorizationViewControllerProtocol,
		 gitHubAuthenticationService: Authenticable,
		 loginFlowCoordinator: LoginFlowCoordinatorProtocol,
		 alertsHandler: AlertsHandlerProtocols) {
		self.viewController = viewController
		self.gitHubAuthenticationService = gitHubAuthenticationService
		self.loginFlowCoordinator = loginFlowCoordinator
		self.alertsHandler = alertsHandler
	}
}

// MARK: - AuthorizationInteractorProtocol

extension AuthorizationInteractor: AuthorizationInteractorProtocol {

	func startAuthorization(with token: String) {
		viewController?.showActivityIndicator()
		Task {
			do {
				let userModel: GitHubUserModel = try await self.gitHubAuthenticationService.authenticateUser(
					with: token,
					by: URLs.authenticateUserURLString
				)
				await self.process(userModel: userModel)
			} catch let error {
				await self.process(error: error)
			}
		}
	}
}

// MARK: - Private methods

@MainActor
private extension AuthorizationInteractor {

	func process(userModel: UserAuthenticationProtocol) {
		viewController?.hideActivityIndicator()
		loginFlowCoordinator?.login()
	}

	func process(error: Error) {
		viewController?.hideActivityIndicator()
		alertsHandler.showErrorAlertWithOkButton(error)
	}
}
