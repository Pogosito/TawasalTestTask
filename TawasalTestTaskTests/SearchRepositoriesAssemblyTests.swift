//
//  SearchRepositoriesAssemblyTests.swift
//  TawasalTestTaskTests
//
//  Created by Pogos Anesyan on 05.11.2022.
//

@testable import TawasalTestTask
import XCTest
import AsyncDisplayKit

final class SearchRepositoriesAssemblyTests: XCTestCase {

	@MainActor func testSearchRepositoriesGetSearchRepositories() {

		// arrange
		let logoutFlowCoordinator = AuthorizationFlowCoordinatorSpy(navigationController: ASDKNavigationController(),
																	authorizationMetadataInteractor: ApplicationServiceSpy())

		// act
		let controller = SearchRepositoriesAssembly.build(logoutFlowCoordinator: logoutFlowCoordinator)

		// assert
		XCTAssertNotNil(controller as! SearchRepositoriesViewController)
	}
}
