//
//  GitHubUserModel.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 23.10.2022.
//

protocol UserAuthenticationProtocol: Decodable {

	var username: String { get }
}

struct GitHubUserModel: UserAuthenticationProtocol {

	var username: String

	private enum CodingKeys: String, CodingKey {
		case username = "login"
	}
}
