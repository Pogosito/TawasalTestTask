//
//  Namespaces.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 23.10.2022.
//

enum Strings {
	static let authorize = "Authorize"
	static let logout = "Logout"

	static let tokenErrorTitle = "Invalid token"
	static let tokenErrorMessage = "Please check the token you entered and try again"

	static let retryErrorTitle = "Please try again"
	static let retryErrorMessage = "Something went wrong, please in again in 5 minutes"

	static let weBrokenErrorTitle = "It's sad, but we broke down"
	static let weBrokenErrorMessage = "Please excuse the inconvenience, we will fix everything soon"

	static let requestErrorTitle = "Something with the network"
	static let requestErrorMessage = "Please check your internet connection and try again"

	static let emptyResultTitle = "No repositories found"
	static let emptyResultMessage = "Repositories with this name were not found. Enter another name"

	static let ok = "OK"

	static let tokenPlaceholder = "Type your token ..."
	static let lan = "Lan:"
	static let repositories = "Repositories"
	static let issues = "Issues"
	static let watchers = "Watchers"
	static let forksCount = "Forks count"
	static let size = "Size"
	static let createdAt = "Created at"
	static let info = "Info"
	static let KB = "KB"
}

enum SemanticAssets {
	static let gitHubLogo = "gitHubLogo"
	static let star = "star"
	static let issues = "issues"
	static let watchers = "watchers"
	static let fork = "fork"
	static let filesize = "filesize"
	static let calendar = "calendar"
}

enum URLs {
	static let baseGitHubURLString = "https://api.github.com"
	static let authenticateUserURLString = "https://api.github.com/user?"
	static let searchReposURLString = "https://api.github.com/search/repositories"
}

enum Headers {
	static let authorization = "Authorization"
	static let accept = "Accept"
}

enum MediaTypes {
	static let full = "application/vnd.github.v3+json"
}

// MARK: - Errors

enum GitHubServicesErrors: Error {

	case applicationBroken

	case serverErrorResponse

	case parseResponseFailed

	case invalidToken

	case requestError

	case cancelRequest
}
