//
//  AuthorizationFlowCoordinatorTests.swift
//  TawasalTestTaskTests
//
//  Created by Pogos Anesyan on 26.10.2022.
//

import XCTest
@testable import TawasalTestTask

final class AuthorizationFlowCoordinatorTests: XCTestCase {

	private var authorizationMetadataInteractor: ApplicationServiceSpy!
	private var navigationController: ASDKNavigationControllerSpy!
	private var sut: AuthorizationFlowCoordinator!

	override func setUp() {
		super.setUp()
		authorizationMetadataInteractor = ApplicationServiceSpy()
		navigationController = ASDKNavigationControllerSpy()
		sut = AuthorizationFlowCoordinator(navigationController: navigationController,
										   authorizationMetadataInteractor: authorizationMetadataInteractor)
	}

	override func tearDown() {
		sut = nil
		authorizationMetadataInteractor = nil
		super.tearDown()
	}
}

@MainActor
extension AuthorizationFlowCoordinatorTests {

	func testStartAuthorizationIfNeededReturnNavigationWithOneController() {

		// act
		let navigationController = sut.startAuthorizationIfNeeded()

		// asserts
		XCTAssertEqual(navigationController.viewControllers.count, 1)
		XCTAssert(authorizationMetadataInteractor.isTheUserAuthorizedDidCall)
	}

	func testStartAuthorizationIfNeededReturnNavigationWithTwoControllers() {

		// arrange
		authorizationMetadataInteractor.setUserAuthorization(status: true)

		// act
		let navigationController = sut.startAuthorizationIfNeeded()

		// asserts
		XCTAssertEqual(navigationController.viewControllers.count, 2)
		XCTAssert(authorizationMetadataInteractor.isTheUserAuthorizedDidCall)
	}

	func testLoginChangeAuthorizationStatusAndPushViewController() {

		// act
		sut.login()

		// asserts
		XCTAssert(authorizationMetadataInteractor.isUserAuthorized)
		XCTAssert(authorizationMetadataInteractor.setUserAuthorizationDidCall)
		XCTAssert(navigationController.pushViewControllerDidCall)
	}

	func testLogoutChangeAuthorizationStatusAndPopViewController() {

		// act
		sut.logout()

		// asserts
		XCTAssertFalse(authorizationMetadataInteractor.isUserAuthorized)
		XCTAssert(authorizationMetadataInteractor.setUserAuthorizationDidCall)
		XCTAssert(navigationController.popViewControllerDidCall)
	}
}
