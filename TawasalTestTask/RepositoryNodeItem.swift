//
//  RepositoryNodeModel.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 30.10.2022.
//

import Foundation

final class RepositoryNodeItem {

	var repositoryId: Int?
	var avatarUrl: String?
	var userLogin: String?
	var repositoryName: String?
	var description: String?
	var stars: Int?
	var language: String?

	lazy var repositoryNode = RepositoryNode(avatarUrl: avatarUrl,
											 userLogin: userLogin,
											 repositoryName: repositoryName,
											 description: description,
											 stars: stars, language: language)

	init(repositoryId: Int? = nil,
		 avatarUrl: String? = nil,
		 userLogin: String? = nil,
		 repositoryName: String? = nil,
		 description: String? = nil,
		 stars: Int? = nil,
		 language: String? = nil) {
		self.repositoryId = repositoryId
		self.avatarUrl = avatarUrl
		self.userLogin = userLogin
		self.repositoryName = repositoryName
		self.description = description
		self.stars = stars
		self.language = language
	}
}
