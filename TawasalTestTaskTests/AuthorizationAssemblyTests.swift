//
//  AuthorizationAssemblyTests.swift
//  TawasalTestTaskTests
//
//  Created by Pogos Anesyan on 26.10.2022.
//


@testable import TawasalTestTask
import XCTest
import AsyncDisplayKit

final class AuthorizationAssemblyTests: XCTestCase {

	@MainActor func testAuthorizationAssemblyGetAuthorizationViewController() {

		// arrange
		let loginFlowCoordinator = AuthorizationFlowCoordinatorSpy(navigationController: ASDKNavigationController(),
																   authorizationMetadataInteractor: ApplicationServiceSpy())

		// act
		let controller = AuthorizationAssembly.build(loginFlowCoordinator: loginFlowCoordinator)

		// assert
		XCTAssertNotNil(controller as! AuthorizationViewController)
	}
}
