//
//  GitHubRepositoriesCacheService.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 06.11.2022.
//

import Foundation

protocol Cacheable {

	func writeRepositoriesSearchInformation<RepositoryModel: Codable>(repositories: RepositoryModel,
																	  name: String, totalPages: Int,
																	  page: Int)

	func readRepositoriesSearchInformation<RepositoryModel: Codable>() -> (repositories: RepositoryModel,
																		   name: String?, totalPages: Int,
																		   page: Int)?

	func clearCache()
}

final class GitHubRepositoriesCacheService {

	private let userDefaults = UserDefaults.standard
	private let decoder = JSONDecoder()
	private let encoder = JSONEncoder()
	private let repositoryKey = "repository"
	private let totalPagesKey = "totalPages"
	private let repositoryNameKey = "repositoryName"
	private let numberOfPageKey = "page"
}

// MARK: - Cacheable

extension GitHubRepositoriesCacheService: Cacheable {

	func writeRepositoriesSearchInformation<RepositoryModel: Codable>(repositories: RepositoryModel,
																	  name: String, totalPages: Int,
																	  page: Int) {
		guard let encodedRepositories = try? self.encoder.encode(repositories) else {
			print("<TALog: Cache> Repositories were NOT cached")
			return
		}

		userDefaults.set(encodedRepositories, forKey: repositoryKey)
		userDefaults.set(name, forKey: repositoryNameKey)
		userDefaults.set(totalPages, forKey: totalPagesKey)
		userDefaults.set(page, forKey: numberOfPageKey)

		print("<TALog: Cache> Repositories were cached | name: \"\(name)\", total pages: \(totalPages) page: \(page)")
	}

	func readRepositoriesSearchInformation<RepositoryModel: Codable>() -> (repositories: RepositoryModel,
																		   name: String?, totalPages: Int,
																		   page: Int)? {
		let decoder = JSONDecoder()
		guard let savedRepositories = userDefaults.value(forKey: repositoryKey) as? Data,
			  let decodedModel = try? decoder.decode(RepositoryModel.self,
													from: savedRepositories) else {
			print("<TALog: Cache> Don't have repositories in cache")
			return nil
		}

		let name = userDefaults.string(forKey: repositoryNameKey)
		let totalPages = userDefaults.integer(forKey: totalPagesKey)
		let page = userDefaults.integer(forKey: numberOfPageKey)

		print("<TALog: Cache> Get repositories from cache | name: \"\(name ?? "{}")\" | total pages: \(totalPages) | page: \(page)")
		return (decodedModel, name, totalPages == 0 ? -1 : totalPages, page == 0 ? 1 : page)
	}

	func clearCache() {
		[repositoryKey, repositoryNameKey, numberOfPageKey].forEach { key in
			userDefaults.removeObject(forKey: key)
		}
		print("<TALog: Cache> The cache has been cleared")
	}
}
