//
//  GithubRepositoryOwner.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 30.10.2022.
//

struct SearchRepositoriesOwner: Decodable {

	let avatarUrl: String?
	let gravatarId: String?
	let id: Int?
	let login: String?
	let receivedEventsUrl: String?
	let type: String?
	let url: String?

	// MARK: - Init

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
		gravatarId = try values.decodeIfPresent(String.self, forKey: .gravatarId)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		login = try values.decodeIfPresent(String.self, forKey: .login)
		receivedEventsUrl = try values.decodeIfPresent(String.self, forKey: .receivedEventsUrl)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}

	init(avatarUrl: String?,
		 gravatarId: String?,
		 id: Int?,
		 login: String?,
		 receivedEventsUrl: String?,
		 type: String?,
		 url: String?) {
		self.avatarUrl = avatarUrl
		self.gravatarId = gravatarId
		self.id = id
		self.login = login
		self.receivedEventsUrl = receivedEventsUrl
		self.type = type
		self.url = url
	}
}

// MARK: - Encodable

extension SearchRepositoriesOwner: Encodable {

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(avatarUrl, forKey: .avatarUrl)
		try container.encode(login, forKey: .login)
	}
}

// MARK: - Coding Keys

private extension SearchRepositoriesOwner {

	enum CodingKeys: String, CodingKey {
		case avatarUrl = "avatar_url"
		case gravatarId = "gravatar_id"
		case id
		case login
		case receivedEventsUrl = "received_events_url"
		case type
		case url
	}
}
