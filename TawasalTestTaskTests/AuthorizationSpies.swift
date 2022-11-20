//
//  AuthorizationSpies.swift
//  TawasalTestTaskTests
//
//  Created by Pogos Anesyan on 26.10.2022.
//

@testable import TawasalTestTask
import XCTest
import AsyncDisplayKit

// MARK: - ViewController

final class AuthorizationViewControllerSpy: AuthorizationViewControllerProtocol {

	private(set) var hideActivityIndicatorDidCall = false
	private(set) var showActivityIndicatorDidCall = false

	func hideActivityIndicator() {
		hideActivityIndicatorDidCall = true
	}
	
	func showActivityIndicator() {
		showActivityIndicatorDidCall = true
	}
}
