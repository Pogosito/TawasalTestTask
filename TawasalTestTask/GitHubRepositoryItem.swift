//
//  GitHubRepositoryItem.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 30.10.2022.
//

import UIKit

struct GitHubRepositoryItem: Decodable {

	var createdAt: String?
	var defaultBranch: String?
	var descriptionField: String?
	var fork: Bool?
	var forksCount: Int?
	var fullName: String?
	var homepage: String?
	var htmlUrl: String?
	var id: Int?
	var language: String?
	var masterBranch: String?
	var name: String?
	var openIssuesCount: Int?
	var owner: SearchRepositoriesOwner?
	var privateField: Bool?
	var pushedAt: String?
	var score: Float?
	var size: Int?
	var stargazersCount: Int?
	var updatedAt: String?
	var url: String?
	var watchersCount: Int?
	var firstImageURLInReadme: URL?

	// MARK: - Init

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		defaultBranch = try values.decodeIfPresent(String.self, forKey: .defaultBranch)
		descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
		fork = try values.decodeIfPresent(Bool.self, forKey: .fork)
		forksCount = try values.decodeIfPresent(Int.self, forKey: .forksCount)
		fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
		homepage = try values.decodeIfPresent(String.self, forKey: .homepage)
		htmlUrl = try values.decodeIfPresent(String.self, forKey: .htmlUrl)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		language = try values.decodeIfPresent(String.self, forKey: .language)
		masterBranch = try values.decodeIfPresent(String.self, forKey: .masterBranch)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		openIssuesCount = try values.decodeIfPresent(Int.self, forKey: .openIssuesCount)
		owner = try values.decodeIfPresent(SearchRepositoriesOwner.self, forKey: .owner)
		privateField = try values.decodeIfPresent(Bool.self, forKey: .privateField)
		pushedAt = try values.decodeIfPresent(String.self, forKey: .pushedAt)
		score = try values.decodeIfPresent(Float.self, forKey: .score)
		size = try values.decodeIfPresent(Int.self, forKey: .size)
		stargazersCount = try values.decodeIfPresent(Int.self, forKey: .stargazersCount)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		watchersCount = try values.decodeIfPresent(Int.self, forKey: .watchersCount)
	}

	init(createdAt: String? = nil,
		 defaultBranch: String? = nil,
		 descriptionField: String? = nil,
		 fork: Bool? = nil,
		 forksCount: Int? = nil,
		 fullName: String? = nil,
		 homepage: String? = nil,
		 htmlUrl: String? = nil,
		 id: Int? = nil,
		 language: String? = nil,
		 masterBranch: String? = nil,
		 name: String? = nil,
		 openIssuesCount: Int? = nil,
		 owner: SearchRepositoriesOwner? = nil,
		 privateField: Bool? = nil,
		 pushedAt: String? = nil,
		 score: Float? = nil,
		 size: Int? = nil,
		 stargazersCount: Int? = nil,
		 updatedAt: String? = nil,
		 url: String? = nil,
		 watchersCount: Int? = nil) {
		self.createdAt = createdAt
		self.defaultBranch = defaultBranch
		self.descriptionField = descriptionField
		self.fork = fork
		self.forksCount = forksCount
		self.fullName = fullName
		self.homepage = homepage
		self.htmlUrl = htmlUrl
		self.id = id
		self.language = language
		self.masterBranch = masterBranch
		self.name = name
		self.openIssuesCount = openIssuesCount
		self.owner = owner
		self.privateField = privateField
		self.pushedAt = pushedAt
		self.score = score
		self.size = size
		self.stargazersCount = stargazersCount
		self.updatedAt = updatedAt
		self.url = url
		self.watchersCount = watchersCount
	}

	func formattedDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let date = dateFormatter.date(from: createdAt ?? "")
		dateFormatter.dateFormat = "dd MMM YYYY"
		dateFormatter.locale = .current
		return dateFormatter.string(from: date ?? Date())
	}
}

// MARK: - Encodable

extension GitHubRepositoryItem: Encodable {

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name, forKey: .name)
		try container.encode(descriptionField, forKey: .descriptionField)
		try container.encode(watchersCount, forKey: .watchersCount)
		try container.encode(language, forKey: .language)
		try container.encode(id, forKey: .id)
		try container.encode(owner, forKey: .owner)
		try container.encode(stargazersCount, forKey: .stargazersCount)
	}
}

// MARK: - Coding Keys

private extension GitHubRepositoryItem {

	enum CodingKeys: String, CodingKey {
		case createdAt = "created_at"
		case defaultBranch = "default_branch"
		case descriptionField = "description"
		case fork
		case forksCount = "forks_count"
		case fullName = "full_name"
		case homepage
		case htmlUrl = "html_url"
		case id
		case language
		case masterBranch = "master_branch"
		case name
		case openIssuesCount = "open_issues_count"
		case owner
		case privateField = "private"
		case pushedAt = "pushed_at"
		case score
		case size
		case stargazersCount = "stargazers_count"
		case updatedAt = "updated_at"
		case url
		case watchersCount = "watchers_count"
	}
}
