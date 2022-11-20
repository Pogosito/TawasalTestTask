//
//  AuthorizationProtocols.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 25.10.2022.
//

import AsyncDisplayKit

@MainActor
protocol StartAuthorizationFlowCoordinatorProtocol {

	init(navigationController: ASDKNavigationController,
		 authorizationMetadataInteractor: AuthorizationMetadataInteractionProtocol)

	func startAuthorizationIfNeeded() -> ASDKNavigationController
}

@MainActor
protocol LoginFlowCoordinatorProtocol: AnyObject {

	func login()
}

@MainActor
protocol LogoutFlowCoordinatorProtocol: AnyObject {

	func logout()
}
