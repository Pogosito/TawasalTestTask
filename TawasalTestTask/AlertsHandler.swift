//
//  AlertsHandlerProtocols.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 01.11.2022.
//

import AsyncDisplayKit

protocol AlertsHandlerProtocols {

	var currentController: UIViewController? { get }

	func showErrorAlertWithOkButton(_ error: Error)
}

final class AlertsHandler {

	weak var currentController: UIViewController?

	init(currentController: UIViewController) {
		self.currentController = currentController
	}
}

// MARK: - AlertsHandlerProtocols

extension AlertsHandler: AlertsHandlerProtocols {

	func showErrorAlertWithOkButton(_ error: Error) {

		var title: String = ""
		var message: String = ""

		switch error as? GitHubServicesErrors {
		case .cancelRequest: return
		case .applicationBroken:
			title = Strings.weBrokenErrorTitle
			message = Strings.weBrokenErrorMessage
		case .serverErrorResponse, .parseResponseFailed:
			title = Strings.retryErrorTitle
			message = Strings.retryErrorMessage
		case .invalidToken:
			title = Strings.tokenErrorTitle
			message = Strings.tokenErrorMessage
		case .requestError:
			title = Strings.requestErrorTitle
			message = Strings.requestErrorMessage
		case .none:
			title = Strings.retryErrorTitle
			message = Strings.retryErrorMessage
		}

		let alert = UIAlertController(title: title,
									  message: message,
									  preferredStyle: .alert)
		alert.addAction(.init(title: Strings.ok, style: .default))
		currentController?.present(alert, animated: true)
	}
}
