//
//  AuthorizationInteractorTests.swift
//  TawasalTestTaskTests
//
//  Created by Pogos Anesyan on 26.10.2022.
//

@testable import TawasalTestTask
import XCTest
import AsyncDisplayKit

final class AuthorizationInteractorTests: XCTestCase {

	private var viewController: AuthorizationViewControllerSpy!
	private var networkClient: NetworkClientSpy!
	private var gitHubAuthenticationService: GitHubAuthenticationServiceSpy!
	private var navigationController: ASDKNavigationControllerSpy!
	private var applicationService: ApplicationServiceSpy!
	private var loginFlowCoordinator: AuthorizationFlowCoordinatorSpy!
	private var alertHandler: AlertsHandlerSpy!
	private var sut: AuthorizationInteractor!

	@MainActor override func setUp() {
		super.setUp()
		viewController = AuthorizationViewControllerSpy()
		networkClient = NetworkClientSpy(urlSession: URLSession.shared)
		gitHubAuthenticationService = GitHubAuthenticationServiceSpy(networkClient: networkClient)
		navigationController = ASDKNavigationControllerSpy()
		applicationService = ApplicationServiceSpy()
		loginFlowCoordinator = AuthorizationFlowCoordinatorSpy(navigationController: navigationController,
															   authorizationMetadataInteractor: applicationService)
		alertHandler = AlertsHandlerSpy()
		sut = AuthorizationInteractor(viewController: viewController,
									  gitHubAuthenticationService: gitHubAuthenticationService,
									  loginFlowCoordinator: loginFlowCoordinator,
									  alertsHandler: alertHandler)
	}

	override func tearDown() {
		sut = nil
		loginFlowCoordinator = nil
		applicationService = nil
		navigationController = nil
		gitHubAuthenticationService = nil
		networkClient = nil
		viewController = nil
		super.tearDown()
	}
}

@MainActor
extension AuthorizationInteractorTests {

	func testStartAuthorizationSuccessAuthorization() {
		// arrange
		let expectation = XCTestExpectation()

		// act
		sut.startAuthorization(with: "")

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			// asserts
			self.defaultAssertions()
			XCTAssertFalse(self.alertHandler.showErrorAlertWithOkButtonDidCall)
			XCTAssert(self.loginFlowCoordinator.loginDidCall)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1)
	}

	func testStartAuthorizationThrowApplicationBrokenFailAuthorization() {
	
		// arrange
		let expectation = XCTestExpectation()
		gitHubAuthenticationService.errorBeingThrown = .applicationBroken
	
		// act
		sut.startAuthorization(with: "")
	
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			// asserts
			self.defaultAssertions()
			XCTAssert(self.alertHandler.showErrorAlertWithOkButtonDidCall)
			XCTAssertFalse(self.loginFlowCoordinator.loginDidCall)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1)
	}

	func testStartAuthThrowServerErrorResponseOrParseResponseFailedFailAuth() {

		// arrange
		let expectation = XCTestExpectation()
		gitHubAuthenticationService.errorBeingThrown = [.parseResponseFailed, .serverErrorResponse].randomElement()

		// act
		sut.startAuthorization(with: "")

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			// asserts
			self.defaultAssertions()
			XCTAssert(self.alertHandler.showErrorAlertWithOkButtonDidCall)
			XCTAssertFalse(self.loginFlowCoordinator.loginDidCall)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1)
	}

	func testStartAuthorizationThrowInvalidTokenFailAuthorization() {

		// arrange
		let expectation = XCTestExpectation()
		gitHubAuthenticationService.errorBeingThrown = .invalidToken
	
		// act
		sut.startAuthorization(with: "")
	
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			// asserts
			self.defaultAssertions()
			XCTAssert(self.alertHandler.showErrorAlertWithOkButtonDidCall)
			XCTAssertFalse(self.loginFlowCoordinator.loginDidCall)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1)
	}

	func testStartAuthorizationThrowRequestErrorFailAuthorization() {

		// arrange
		let expectation = XCTestExpectation()
		gitHubAuthenticationService.errorBeingThrown = .requestError
	
		// act
		sut.startAuthorization(with: "")
	
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			// asserts
			self.defaultAssertions()
			XCTAssert(self.alertHandler.showErrorAlertWithOkButtonDidCall)
			XCTAssertFalse(self.loginFlowCoordinator.loginDidCall)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1)
	}
}

private extension AuthorizationInteractorTests {

	func defaultAssertions() {
		XCTAssert(viewController.hideActivityIndicatorDidCall)
		XCTAssert(viewController.showActivityIndicatorDidCall)
		XCTAssert(gitHubAuthenticationService.authenticateUserDidCall)
	}
}
