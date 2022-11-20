//
//  GitHubExtractReadmeService.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 07.11.2022.
//

import Foundation

protocol ReadmeExtractable {

	init(networkClient: Networkable)

	func extractReadme(dataForGettingReadme: (ownerName: String,
											  repositoryName: String),
					   by urlString: String) async -> GitHubReadmeModel?
}

final class GitHubExtractReadmeService {

	private let networkClient: Networkable

	// MARK: - Init

	init(networkClient: Networkable) {
		self.networkClient = networkClient
	}
}

// MARK: - ReadmeExtractable

extension GitHubExtractReadmeService: ReadmeExtractable {

	func extractReadme(dataForGettingReadme: (ownerName: String,
											  repositoryName: String),
					   by urlString: String) async -> GitHubReadmeModel? {

		let ownerName = dataForGettingReadme.ownerName
		let repositoryName = dataForGettingReadme.repositoryName

		guard let url = URL(string: "\(urlString)/repos/\(ownerName)/\(repositoryName)/readme") else {
			return nil
		}

		var extractReadmeRequest = URLRequest(url: url)
		extractReadmeRequest.addValue(MediaTypes.full, forHTTPHeaderField: Headers.accept)

		return try? await self.networkClient.send(request: extractReadmeRequest)
	}
}
