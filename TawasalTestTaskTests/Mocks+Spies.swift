//
//  Mocks+Spies.swift
//  TawasalTestTaskTests
//
//  Created by Pogos Anesyan on 25.10.2022.
//


@testable import TawasalTestTask
import AsyncDisplayKit

enum FakeError: Error { case fakeError }

struct FakeResponse: Decodable {}

// MARK: - MockURLPorotocol

final class MockURLProtocol: URLProtocol {

	static var requestHandler: ((URLRequest) throws -> (Data?, HTTPURLResponse?, Error?))?

	override func stopLoading() {}

	override class func canInit(with request: URLRequest) -> Bool {
		return true
	}

	override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}

	override func startLoading() {
		guard let handler = MockURLProtocol.requestHandler else {
			fatalError("MockURLProtocol ERROR: Handler is not set.")
		}

		do {
			let (data, response, error) = try handler(request)
			if let response = response {
				client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
			}

			if let error = error {
				client?.urlProtocol(self, didFailWithError: error)
				client?.urlProtocolDidFinishLoading(self)
				return
			}
	
			if let data = data {
				client?.urlProtocol(self, didLoad: data)
			}

			client?.urlProtocolDidFinishLoading(self)

		} catch {
			client?.urlProtocol(self, didFailWithError: error)
		}
	}
}

// MARK: - NetworkClientSpy

final class NetworkClientSpy: Networkable {

	private(set) var sendDidCall = false
	var data: Data = Data()

	init(urlSession: URLSession) {}

	func send<ResponseModel: Decodable>(request: URLRequest) async throws -> ResponseModel {
		sendDidCall = true
		return try! JSONDecoder().decode(ResponseModel.self, from: data)
	}
}

// MARK: - ApplicationServiceSpy

final class ApplicationServiceSpy: AuthorizationMetadataInteractionProtocol {

	private(set) var isUserAuthorized = false
	private(set) var isTheUserAuthorizedDidCall = false
	private(set) var setUserAuthorizationDidCall = false

	func isTheUserAuthorized() -> Bool {
		isTheUserAuthorizedDidCall = true
		return isUserAuthorized
	}

	func setUserAuthorization(status: Bool) {
		setUserAuthorizationDidCall = true
		isUserAuthorized = status
	}
}

// MARK: - ASDKNavigationControllerSpy

final class ASDKNavigationControllerSpy: ASDKNavigationController {

	private(set) var pushViewControllerDidCall = false
	private(set) var popViewControllerDidCall = false
	private(set) var presentDidCall = false

	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		pushViewControllerDidCall = true
	}

	override func popViewController(animated: Bool) -> UIViewController? {
		popViewControllerDidCall = true
		return ASDKViewController<ASDisplayNode>()
	}

	override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
		presentDidCall = true
	}
}

// MARK: - ASDKViewControllerSpy

final class ASDKViewControllerSpy: ASDKViewController<ASDisplayNode> {

	private(set) var presentDidCall = false
	private(set) var _presentedViewController: UIViewController?

	override func present(_ viewControllerToPresent: UIViewController,
						  animated flag: Bool, completion: (() -> Void)? = nil) {
		_presentedViewController = viewControllerToPresent
		presentDidCall = true
	}
}

// MARK: - AuthorizationFlowCoordinatorSpy

final class AuthorizationFlowCoordinatorSpy: StartAuthorizationFlowCoordinatorProtocol,
											 LoginFlowCoordinatorProtocol,
											 LogoutFlowCoordinatorProtocol {

	private(set) var startAuthorizationIfNeededDidCall = false
	private(set) var loginDidCall = false
	private(set) var logoutDidCall = false

	init(navigationController: ASDKNavigationController,
		 authorizationMetadataInteractor: AuthorizationMetadataInteractionProtocol) {
	}

	func startAuthorizationIfNeeded() -> ASDKNavigationController {
		startAuthorizationIfNeededDidCall = true
		return ASDKNavigationController()
	}
	
	func login() {
		loginDidCall = true
	}
	
	func logout() {
		logoutDidCall = true
	}
}

// MARK: - GitHubAuthenticationServiceSpy

final class GitHubAuthenticationServiceSpy: Authenticable {

	private(set) var authenticateUserDidCall = false
	var errorBeingThrown: GitHubServicesErrors?

	init(networkClient: Networkable) {}

	func authenticateUser<T: UserAuthenticationProtocol>(with token: String, by urlString: String) async throws -> T {
		authenticateUserDidCall = true
		if let safeError = errorBeingThrown { throw safeError }
		return GitHubUserModel(username: "") as! T
	}
}

// MARK: - AlertsHandlerSpy

final class AlertsHandlerSpy: AlertsHandlerProtocols {

	private(set) var showErrorAlertWithOkButtonDidCall = false

	var currentController: UIViewController?

	func showErrorAlertWithOkButton(_ error: Error) {
		showErrorAlertWithOkButtonDidCall = true
	}
}
