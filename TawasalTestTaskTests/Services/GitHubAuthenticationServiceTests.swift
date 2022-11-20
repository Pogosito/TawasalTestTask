//
//  GitHubAuthenticationServiceTests.swift
//  TawasalTestTaskTests
//
//  Created by Pogos Anesyan on 30.10.2022.
//

import XCTest
@testable import TawasalTestTask

final class GitHubAuthenticationServiceTests: XCTestCase {

	private var networkClient: NetworkClientSpy!
	private var sut: GitHubAuthenticationService!

	override func setUp() {
		super.setUp()
		networkClient = NetworkClientSpy(urlSession: URLSession.shared)
		sut = GitHubAuthenticationService(networkClient: networkClient)
	}

	override func tearDown() {
		networkClient = nil
		sut = nil
		super.tearDown()
	}
}

extension GitHubAuthenticationServiceTests {

	func testAuthenticateUserPassWrongUrlThrowApplicationBroken() async {
		do {
			// act
			let _: GitHubUserModel = try await sut.authenticateUser(with: "", by: "")
			XCTFail("Function must throw")
		} catch {
			// assert
			XCTAssertFalse(networkClient.sendDidCall)
			XCTAssertEqual(error as! GitHubServicesErrors, .applicationBroken)
		}
	}

	func testAuthenticateUserSendRequest() async {

		// arrange
		networkClient.data = """
			{ "login": ""}
		""".data(using: .utf8)!

		// act
		let _: GitHubUserModel? = try? await sut.authenticateUser(with: "", by: "User")
	
		// assert
		XCTAssert(networkClient.sendDidCall)
	}
}
