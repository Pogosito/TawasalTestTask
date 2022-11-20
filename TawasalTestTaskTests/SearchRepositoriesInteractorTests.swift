//
//  SearchRepositoriesInteractorTests.swift
//  TawasalTestTaskTests
//
//  Created by Pogos Anesyan on 19.11.2022.
//

@testable import TawasalTestTask
import AsyncDisplayKit
import XCTest

final class SearchRepositoriesInteractorTests: XCTestCase {

	private var sut: SearchRepositoriesInteractor!
	private var presenter: SearchRepositoriesPresenterSpy!
	private var router: SearchRepositoriesRouterSpy!
	private var networkClient: NetworkClientSpy!
	private var searchRepositoriesService: GitHubSearchRepositoriesServiceSpy!
	private var logoutFlowCoordinator: AuthorizationFlowCoordinatorSpy!
	private var alertsHandler: AlertsHandlerSpy!
	private var repositoriesCacheService: GitHubRepositoriesCacheServiceSpy!
	private var readmeExtractor: GitHubExtractReadmeServiceSpy!
	private var navigationController: ASDKNavigationControllerSpy!
	private var applicationService: ApplicationServiceSpy!
	private var contextSpy: ASBatchContextSpy!

	@MainActor override func setUp() {
		super.setUp()
		presenter = SearchRepositoriesPresenterSpy()
		router = SearchRepositoriesRouterSpy()
		networkClient = NetworkClientSpy(urlSession: URLSession.shared)
		searchRepositoriesService = GitHubSearchRepositoriesServiceSpy(networkClient: networkClient)
		navigationController = ASDKNavigationControllerSpy()
		applicationService = ApplicationServiceSpy()
		logoutFlowCoordinator = AuthorizationFlowCoordinatorSpy(navigationController: navigationController,
																authorizationMetadataInteractor: applicationService)
		alertsHandler = AlertsHandlerSpy()
		repositoriesCacheService = GitHubRepositoriesCacheServiceSpy()
		readmeExtractor = GitHubExtractReadmeServiceSpy(networkClient: networkClient)
		contextSpy = ASBatchContextSpy()

		sut = SearchRepositoriesInteractor(presenter: presenter,
										   router: router,
										   gitHubSearchRepositoriesService: searchRepositoriesService,
										   logoutFlowCoordinator: logoutFlowCoordinator,
										   alertsHandler: alertsHandler,
										   repositoriesCacheService: repositoriesCacheService,
										   readmeExtractor: readmeExtractor)
	}

	override func tearDown() {
		sut = nil
		readmeExtractor = nil
		repositoriesCacheService = nil
		alertsHandler = nil
		logoutFlowCoordinator = nil
		applicationService = nil
		navigationController = nil
		searchRepositoriesService = nil
		networkClient = nil
		router = nil
		presenter = nil
		super.tearDown()
	}
}

extension SearchRepositoriesInteractorTests {

	// MARK: - Initial

	func testGetRepositoriesWhenCacheIsEmptyMakeRequest() {
		// arrange
		let expectation = XCTestExpectation()
		repositoriesCacheService.repositoriesJSON = nil
		searchRepositoriesService.response = SearchRepositoriesResponse(incompleteResults: true,
																		items: [], totalCount: 1233)
		// act
		sut.getRepositories(by: "name", context: contextSpy)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			// assert
			XCTAssertFalse(self.repositoriesCacheService.readRepositoriesSearchInformationDidCall)
			XCTAssert(self.searchRepositoriesService.searchRepositoriesDidCall)
			XCTAssert(self.presenter.presentRepositoriesDidCall)
			XCTAssertEqual(self.sut.totalPages, 13)
			XCTAssertFalse(self.router.presentEmptyResultAlertDidCall)
			XCTAssert(self.contextSpy.completeBatchFetchingDidCall)
			XCTAssert(self.contextSpy.didCompleteFetching)
			XCTAssertFalse(self.sut.wasLastShowedRepositoriesCached)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1)
	}

	func testGetRepositoriesCacheIsNotEmptyGetDataFromCache() {

		// arrange
		let expectation = XCTestExpectation()
		repositoriesCacheService.repositoriesJSON = "[{ \"id\": 22 }]"

		// act
		sut.getRepositories(by: "", context: contextSpy)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			// assert
			XCTAssert(self.repositoriesCacheService.readRepositoriesSearchInformationDidCall)
			XCTAssert(self.presenter.presentTextInSearchControllerDidCall)
			XCTAssert(self.presenter.presentRepositoriesDidCall)
			XCTAssertFalse(self.presenter.wasRepositoriesInserted)
			XCTAssertEqual(self.sut.lastSearchedName, "Pogos")
			XCTAssertEqual(self.sut.totalPages, 10)
			XCTAssertEqual(self.sut.pageCounter, 1)
			XCTAssert(self.contextSpy.completeBatchFetchingDidCall)
			XCTAssert(self.contextSpy.didCompleteFetching)
			XCTAssertFalse(self.sut.wasLastShowedRepositoriesCached)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1)
	}

	func testGetRepositoriesBySearchingReloadScreen() {
		// arrange
		let expectation = XCTestExpectation()

		// act
		sut.getRepositories(by: "name", context: nil)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			// assert
			XCTAssertFalse(self.repositoriesCacheService.readRepositoriesSearchInformationDidCall)
			XCTAssertFalse(self.presenter.presentTextInSearchControllerDidCall)
			XCTAssert(self.presenter.presentRepositoriesDidCall)
			XCTAssertEqual(self.sut.pageCounter, 1)
			XCTAssertFalse(self.sut.wasLastShowedRepositoriesCached)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1)
	}

	// MARK: - NOT Initial

	func testGetRepositoriesWhenScrollingInsertItems() {
		
		// arrange
		let expectation = XCTestExpectation()
		sut.totalPages = 20
		sut.pageCounter = 10

		// act
		sut.getRepositories(by: "name", context: contextSpy)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			// assert
			XCTAssert(self.presenter.presentRepositoriesDidCall)
			XCTAssert(self.presenter.wasRepositoriesInserted)
			XCTAssertEqual(self.sut.lastSearchedName, "name")
			XCTAssertEqual(self.sut.totalPages, 20)
			XCTAssertEqual(self.sut.pageCounter, 11)
			XCTAssert(self.contextSpy.completeBatchFetchingDidCall)
			XCTAssert(self.contextSpy.didCompleteFetching)
			XCTAssertFalse(self.repositoriesCacheService.readRepositoriesSearchInformationDidCall)
			XCTAssertFalse(self.presenter.presentTextInSearchControllerDidCall)
			XCTAssertFalse(self.sut.wasLastShowedRepositoriesCached)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1)
	}

	func testGetRepositoriesWhenOnTheLastPageHideFooterIndicator() {

		// arrange
		let expectation = XCTestExpectation()
		sut.pageCounter = 9
		sut.totalPages = 10

		// act
		sut.getRepositories(by: "name", context: contextSpy)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			// assert
			XCTAssert(self.presenter.hideFooterActivityIndicatorDidCall)
			XCTAssertEqual(self.sut.pageCounter, self.sut.totalPages)
			XCTAssert(self.contextSpy.completeBatchFetchingDidCall)
			XCTAssert(self.contextSpy.didCompleteFetching)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1)
	}

	func testGetRepositoriesGetErrorFromSearchingServicePresentError() {

		// arrange
		let expectation = XCTestExpectation()
		repositoriesCacheService.repositoriesJSON = nil
		searchRepositoriesService.errorBeingThrown = .applicationBroken
		// act
		sut.getRepositories(by: "name", context: contextSpy)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			// assert
			XCTAssert(self.presenter.hideActivityIndicatorDidCall)
			XCTAssert(self.contextSpy.cancelBatchFetchingDidCall)
			XCTAssert(self.alertsHandler.showErrorAlertWithOkButtonDidCall)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1)
	}

	func testGetRepositoriesGetEmptyResultPresentAlert() {
	
		// arrange
		let expectation = XCTestExpectation()
		searchRepositoriesService.response = SearchRepositoriesResponse(incompleteResults: true, items: [], totalCount: 0)

		// act
		sut.getRepositories(by: "", context: nil)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			// assert
			XCTAssert(self.presenter.hideActivityIndicatorDidCall)
			XCTAssert(self.router.presentEmptyResultAlertDidCall)
			XCTAssertFalse(self.contextSpy.completeBatchFetchingDidCall)
			XCTAssertFalse(self.contextSpy.didCompleteFetching)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1)
	}

	func testAppGoBackgroundWhenDataNotCachedCacheData() {
	
		// act
		NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: sut)

		// assert
		XCTAssert(repositoriesCacheService.writeRepositoriesSearchInformationDidCall)
		XCTAssert(sut.wasLastShowedRepositoriesCached)
	}

	func testAppGoBackgroundWhenDataCachedDontCacheData() {

		// arrange
		sut.wasLastShowedRepositoriesCached = true

		// act
		NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: sut)

		// assert
		XCTAssertFalse(repositoriesCacheService.writeRepositoriesSearchInformationDidCall)
		XCTAssert(sut.wasLastShowedRepositoriesCached)
	}

	@MainActor func testExtractReadmePresentAlreadyDownloadedImage() {

		// arrange
		let expectation = XCTestExpectation()
		repositoriesCacheService.repositoriesJSON = nil
		var item = GitHubRepositoryItem()
		item.id = 1
		item.firstImageURLInReadme = URL(string: "image")!

		searchRepositoriesService.response = SearchRepositoriesResponse(incompleteResults: true,
																		items: [item], totalCount: 1233)
		sut.getRepositories(by: "asd", context: contextSpy)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			// act
			self.sut.extractReadme(repositoryId: 1, ownerName: "sd", repositoryName: "sd")

			XCTAssertFalse(self.readmeExtractor.extractReadmeDidCall)
			XCTAssert(self.presenter.presentFirstReadmeImageDidCall)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1)
	}

	@MainActor func testLogoutClearCacheAndPop() async {

		// act
		sut.logout()

		// assert
		XCTAssert(repositoriesCacheService.clearCacheDidCall)
		XCTAssert(logoutFlowCoordinator.logoutDidCall)
	}
}
