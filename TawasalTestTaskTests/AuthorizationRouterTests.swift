//
//  AuthorizationRouterTests.swift
//  TawasalTestTaskTests
//
//  Created by Pogos Anesyan on 29.10.2022.
//

@testable import TawasalTestTask
import XCTest
import AsyncDisplayKit

final class AuthorizationRouterTests: XCTestCase {

	private var viewController: ASDKViewControllerSpy!
	private var sut: AlertsHandler!

	override func setUp() {
		super.setUp()
		viewController = ASDKViewControllerSpy()
		sut = AlertsHandler(currentController: viewController)
	}

	override func tearDown() {
		sut = nil
		viewController = nil
		super.tearDown()
	}
}

extension AuthorizationRouterTests {

	func testPresentTokenErrorAlertPresentAlert() {

		// act
		sut.showErrorAlertWithOkButton(GitHubServicesErrors.invalidToken)
		let alert = viewController._presentedViewController as! UIAlertController

		// assert
		XCTAssert(viewController.presentDidCall)
		makeAssertions(about: alert, Strings.tokenErrorTitle,
					   Strings.tokenErrorMessage)
	}

	func testPresentRetryErrorAlertPresentAlert() {

		// act
		sut.showErrorAlertWithOkButton(GitHubServicesErrors.serverErrorResponse)
		let alert = viewController._presentedViewController as! UIAlertController

		// assert
		XCTAssert(viewController.presentDidCall)
		makeAssertions(about: alert, Strings.retryErrorTitle,
					   Strings.retryErrorMessage)
	}

	func testPresentWeBrokenErrorAlertPresentAlert() {

		// act
		sut.showErrorAlertWithOkButton(GitHubServicesErrors.applicationBroken)
		let alert = viewController._presentedViewController as! UIAlertController

		// assert
		XCTAssert(viewController.presentDidCall)
		makeAssertions(about: alert, Strings.weBrokenErrorTitle,
					   Strings.weBrokenErrorMessage)
	}

	func testPresentRequestErrorAlertPresentAlert() {

		// act
		sut.showErrorAlertWithOkButton(GitHubServicesErrors.requestError)
		let alert = viewController._presentedViewController as! UIAlertController

		// assert
		XCTAssert(viewController.presentDidCall)
		makeAssertions(about: alert, Strings.requestErrorTitle,
					   Strings.requestErrorMessage)
	}
}


private extension AuthorizationRouterTests {

	func makeAssertions(about alert: UIAlertController,
						_ title: String,
						_ message: String) {
		XCTAssertEqual(alert.title, title)
		XCTAssertEqual(alert.message, message)
		XCTAssertEqual(alert.actions.count, 1)
		XCTAssertEqual(alert.actions.first?.title, Strings.ok)
		XCTAssertEqual(alert.actions.first?.style, .default)
	}
}
