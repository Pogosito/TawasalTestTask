//
//  GitHubSearchRepositoriesService.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 24.10.2022.
//

import Foundation

protocol RepositoriesSearchable {

	init(networkClient: Networkable)

	func searchRepositories(by name: String,
							page: Int,
							by urlString: String) async throws -> SearchRepositoriesResponse
}

final class GitHubSearchRepositoriesService {

	// MARK: - Private properties

	private let networkClient: Networkable
	private let numberOfRepositoriesPerPage = "100"

	// MARK: - Init

	init(networkClient: Networkable) {
		self.networkClient = networkClient
	}
}

// MARK: - RepositoriesSearchable

extension GitHubSearchRepositoriesService: RepositoriesSearchable {

	func searchRepositories(by name: String,
							page: Int,
							by urlString: String) async throws -> SearchRepositoriesResponse {
		guard var searchRepositoriesURLComponents = URLComponents(string: urlString) else {
			throw GitHubServicesErrors.applicationBroken
		}

		var queryItems: [URLQueryItem] = []

		queryItems.append(URLQueryItem(name: Keys.text.rawValue, value: name))
		queryItems.append(URLQueryItem(name: Keys.page.rawValue, value: String(page)))
		queryItems.append(URLQueryItem(name: Keys.perPage.rawValue, value: numberOfRepositoriesPerPage))

		searchRepositoriesURLComponents.queryItems = queryItems

		guard let safeURL = searchRepositoriesURLComponents.url else {
			throw GitHubServicesErrors.applicationBroken
		}

		var searchRepositoriesRequest = URLRequest(url: safeURL)

		searchRepositoriesRequest.addValue(MediaTypes.full, forHTTPHeaderField: Headers.accept)
		let repositories: SearchRepositoriesResponse = try await networkClient.send(request: searchRepositoriesRequest)

		return repositories
	}
}

// MARK: - Keys

private extension GitHubSearchRepositoriesService {

	enum Keys: String {
		case text = "q"
		case order
		case sort
		case perPage = "per_page"
		case page
	}
}
