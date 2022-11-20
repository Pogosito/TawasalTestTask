//
//  NetworkClient.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 29.10.2022.
//

import Foundation

protocol Networkable {

	init(urlSession: URLSession)

	func send<ResponseModel: Decodable>(request: URLRequest) async throws -> ResponseModel
}

final class NetworkClient {

	// MARK: - Private properties

	private let urlSession: URLSession

	// MARK: - Init

	init(urlSession: URLSession) {
		self.urlSession = urlSession
	}
}

extension NetworkClient: Networkable {

	func send<ResponseModel: Decodable>(request: URLRequest) async throws -> ResponseModel {
		try await withCheckedThrowingContinuation { continuation in
			urlSession.dataTask(with: request) { data, response, error in

				guard error == nil else {
					continuation.resume(throwing: (error as? NSError)?.code == -999
										? GitHubServicesErrors.cancelRequest
										: GitHubServicesErrors.requestError)
					return
				}

				guard let httpResponse = response as? HTTPURLResponse else {
					continuation.resume(throwing: GitHubServicesErrors.applicationBroken)
					return
				}

				if httpResponse.statusCode == 401 {
					continuation.resume(throwing: GitHubServicesErrors.invalidToken)
					return
				} else if httpResponse.statusCode != 200 {
					continuation.resume(throwing: GitHubServicesErrors.serverErrorResponse)
					return
				}

				guard let safeData = data,
					  let decodedResponse = try? JSONDecoder().decode(ResponseModel.self, from: safeData) else {
					continuation.resume(throwing: GitHubServicesErrors.parseResponseFailed)
					return
				}

				continuation.resume(returning: decodedResponse)
			}.resume()
		}
	}
}
