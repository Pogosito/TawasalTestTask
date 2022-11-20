//
//  GitHubSearchRepositoriesResponse.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 30.10.2022.
//

struct SearchRepositoriesResponse: Decodable {

	let incompleteResults: Bool?
	let items: [GitHubRepositoryItem]
	let totalCount: Int?
	
	// MARK: - Init

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		incompleteResults = try values.decodeIfPresent(Bool.self, forKey: .incompleteResults)
		items = try values.decodeIfPresent([GitHubRepositoryItem].self, forKey: .items) ?? []
		totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
	}

	init(incompleteResults: Bool,
		 items: [GitHubRepositoryItem],
		 totalCount: Int) {
		self.incompleteResults = incompleteResults
		self.items = items
		self.totalCount = totalCount
	}
}

// MARK: - Encodable

extension SearchRepositoriesResponse: Encodable {

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(incompleteResults, forKey: .incompleteResults)
		try container.encode(totalCount, forKey: .totalCount)
		try container.encode(items, forKey: .items)
	}
}

// MARK: - Coding Keys

private extension SearchRepositoriesResponse {

	enum CodingKeys: String, CodingKey {
		case items
		case totalCount = "total_count"
		case incompleteResults = "incomplete_results"
	}
}
