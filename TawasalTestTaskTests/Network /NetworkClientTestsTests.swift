//
//  GithubAuthenticationServiceTests.swift
//  TawasalTestTaskTests
//
//  Created by Pogos Anesyan on 25.10.2022.
//

import XCTest
@testable import TawasalTestTask

final class NetworkClientTests: XCTestCase {

	private var sut: NetworkClient!

	override func setUp() {
		super.setUp()
		URLProtocol.registerClass(MockURLProtocol.self)
		let configurationWithMock = URLSessionConfiguration.default
		configurationWithMock.protocolClasses = [MockURLProtocol.self]
		let urlSession = URLSession(configuration: configurationWithMock)
		sut = NetworkClient(urlSession: urlSession)
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}
}

extension NetworkClientTests {

	func testSendRequestForAuthenticateGetAuthUser() async throws {

		// arrange
		let jsonString = """
		{ "login": "Pogosito"}
		"""

		let data = jsonString.data(using: .utf8)

		MockURLProtocol.requestHandler = { request in
			let response = HTTPURLResponse(url: URL(string: "user")!,
										   statusCode: 200, httpVersion: nil,
										   headerFields: nil)!
			return (data, response, nil)
		}
		let request = URLRequest(url: URL(string: "User")!)

		// act
		let userName: GitHubUserModel? = try? await sut.send(request: request)

		// assert
		XCTAssertEqual(userName?.username, "Pogosito")
	}

	func testAuthenticateUserGetWrongJSONThrowParseResponseFailed() async throws {

		// arrange
		let jsonString = """
		{ "ssssssssss": "Pogosito"}
		"""

		let data = jsonString.data(using: .utf8)

		MockURLProtocol.requestHandler = { request in
			let response = HTTPURLResponse(url: URL(string: "user")!,
										   statusCode: 200, httpVersion: nil,
										   headerFields: nil)!
			return (data, response, nil)
		}

		try! await assertionAboutThrowing(error: .parseResponseFailed)
	}

	func testAuthenticateUserGet401CodeThrowInvalidToken() async {

		// arrange
		MockURLProtocol.requestHandler = { request in
			let response = HTTPURLResponse(url: URL(string: "user")!,
										   statusCode: 401, httpVersion: nil,
										   headerFields: nil)!
			return (nil, response, nil)
		}

		try! await assertionAboutThrowing(error: .invalidToken)
	}

	func testAuthenticateUserGetUnknownCodeThrowServerErrorResponse() async {

		// arrange
		MockURLProtocol.requestHandler = { request in
			let response = HTTPURLResponse(url: URL(string: "user")!,
										   statusCode: 300, httpVersion: nil,
										   headerFields: nil)!
			return (nil, response, nil)
		}

		try! await assertionAboutThrowing(error: .serverErrorResponse)
	}

	func testAuthenticateUserGetErrorThrowRequestError() async {
		// arrange
		MockURLProtocol.requestHandler = { request in
			let response = HTTPURLResponse(url: URL(string: "user")!,
										   statusCode: 300, httpVersion: nil,
										   headerFields: nil)!
			return (nil, response, FakeError.fakeError)
		}

		try! await assertionAboutThrowing(error: .requestError)
	}

	func testAuthenticateUserGetInvalidResponseThrowApplicationBroken() async {
		// arrange
		MockURLProtocol.requestHandler = { request in
			return (nil, nil, nil)
		}

		try! await assertionAboutThrowing(error: .applicationBroken)
	}
}

private extension NetworkClientTests {

	func assertionAboutThrowing(error: GitHubServicesErrors) async throws {
		let request = URLRequest(url: URL(string: "User")!)
		do {
			// act
			let _: GitHubUserModel = try await sut.send(request: request)
			XCTFail("Function must throw")
		} catch let catchedError {
			// assert
			XCTAssertEqual(catchedError as! GitHubServicesErrors, error)
		}
	}
}
