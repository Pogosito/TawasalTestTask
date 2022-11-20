//
//  SearchRepositoriesViewControllerTests.swift
//  TawasalTestTaskTests
//
//  Created by Pogos Anesyan on 05.11.2022.
//

@testable import TawasalTestTask
import XCTest

final class SearchRepositoriesViewControllerTests: XCTestCase {

	private var interactor: SearchRepositoriesInteractorSpy!
	private var sut: SearchRepositoriesViewController!

	override func setUp() {
		super.setUp()
		sut = SearchRepositoriesViewController()
		sut.interactor = interactor
	}

	override func tearDown() {
		interactor = nil
		sut = nil
		super.tearDown()
	}
}

extension SearchRepositoriesViewControllerTests {

	func testInsertRepositoriesChangeRepositoriesCount() {

		// arrange
		let repositories = makeRepositoriesStub()

		// acts
		sut.insert(newRepositories: repositories)
		sut.insert(newRepositories: repositories)

		// assert
		XCTAssertEqual(repositories.count * 2, sut.node.numberOfRows(inSection: 0))
		XCTAssertEqual(repositories.count * 2, sut.repositories.count)
	}

	func testReloadTableTableWasReloaded() {

		// arrange
		let repositories = makeRepositoriesStub()

		// acts
		sut.reloadTable(with: repositories)
		sut.reloadTable(with: repositories)
		sut.reloadTable(with: repositories)

		// assert
		XCTAssertEqual(repositories.count, sut.node.numberOfRows(inSection: 0))
		XCTAssertEqual(repositories.count, sut.repositories.count)
	}

	func testSetFirstReadmeImageSuccessFindModelAndSetImage() {

		// arrange
		let url = URL(string: "image")!

		let items = makeRepositoriesStub()
		let itemIndex = 0

		sut.reloadTable(with: items)

		// act
		sut.setFirstReadmeImage(by: url, for: itemIndex)

		// assert
		XCTAssertNotNil(
			items[itemIndex].repositoryNode.firstImageFromReadme.url
		)
	}

	func testSetFirstImageDontFindModelImageDidNotSet() {

		// arrange
		let url = URL(string: "image")!

		let items = makeRepositoriesStub()
		let itemIndex = 10

		sut.reloadTable(with: items)

		// act
		sut.setFirstReadmeImage(by: url, for: itemIndex)

		// assert
		for item in items {
			XCTAssertNil(item.repositoryNode.firstImageFromReadme.url)
		}
	}

	func testSetSearchControllerTextChangeText() {

		// arrange
		let searchBarText = "foo"

		// act
		sut.viewDidLoad()
		sut.setSearchController(text: searchBarText)

		// assert
		XCTAssertEqual(sut.navigationItem.searchController?.searchBar.text, searchBarText)
	}
}

private extension SearchRepositoriesViewControllerTests {

	func makeRepositoriesStub() -> [RepositoryNodeItem] {
		[RepositoryNodeItem(repositoryId: 0),
		 RepositoryNodeItem(repositoryId: 1),
		 RepositoryNodeItem(repositoryId: 2),
		 RepositoryNodeItem(repositoryId: 3)]
	}
}
