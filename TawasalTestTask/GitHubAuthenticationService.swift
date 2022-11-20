//
//  GitHubAuthenticationService.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 23.10.2022.
//

import Foundation

protocol Authenticable {

	init(networkClient: Networkable)

	func authenticateUser<T: UserAuthenticationProtocol>(with token: String,
														 by urlString: String) async throws -> T
}

final class GitHubAuthenticationService {

	// MARK: - Private properties

	private let networkClient: Networkable

	// MARK: - Init

	init(networkClient: Networkable) {
		self.networkClient = networkClient
	}
}

// MARK: - Authenticable

extension GitHubAuthenticationService: Authenticable {

	func authenticateUser<T: UserAuthenticationProtocol>(with token: String,
														 by urlString: String) async throws -> T {

		guard let authenticateUserUrl = URL(string: urlString) else {
			throw GitHubServicesErrors.applicationBroken
		}

		var authenticateUserRequest = URLRequest(url: authenticateUserUrl)
		authenticateUserRequest.addValue("token \(token)", forHTTPHeaderField: Headers.authorization)

		return try await networkClient.send(request: authenticateUserRequest)
	}
}
