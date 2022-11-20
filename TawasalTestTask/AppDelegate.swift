//
//  AppDelegate.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 21.10.2022.
//

import AsyncDisplayKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
		if isUnitTesting { return true }

		window = UIWindow()

		let applicationService = ApplicationService()
		let navigationController = ASDKNavigationController()

		let authorizationCoordinator = AuthorizationFlowCoordinator(
			navigationController: navigationController,
			authorizationMetadataInteractor: applicationService
		)

		window?.rootViewController = authorizationCoordinator.startAuthorizationIfNeeded()
		window?.makeKeyAndVisible()
		return true
	}
}
