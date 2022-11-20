//
//  UserDefaultsFacade.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 23.10.2022.
//

import Foundation

protocol AuthorizationMetadataInteractionProtocol {

	func isTheUserAuthorized() -> Bool

	func setUserAuthorization(status: Bool)
}

final class ApplicationService {

	private let userDefaults = UserDefaults.standard

	private enum UserDefaultsKey: String {
		case isTheUserAuthorized
	}
}

// MARK: - AuthorizationMetadataInteractionProtocol

extension ApplicationService: AuthorizationMetadataInteractionProtocol {

	func isTheUserAuthorized() -> Bool {
		userDefaults.bool(forKey: UserDefaultsKey.isTheUserAuthorized.rawValue)
	}

	func setUserAuthorization(status: Bool) {
		userDefaults.set(status, forKey: UserDefaultsKey.isTheUserAuthorized.rawValue)
	}
}
