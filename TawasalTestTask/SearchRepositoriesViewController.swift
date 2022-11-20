//
//  
//  SearchRepositoriesViewController.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 25.10.2022.
//
//

import AsyncDisplayKit
import Darwin
import CoreGraphics

protocol SearchRepositoriesViewControllerProtocol: AnyObject {

	func reloadTable(with newRepositories: [RepositoryNodeItem])

	func insert(newRepositories: [RepositoryNodeItem])

	func setFirstReadmeImage(by url: URL, for repositoryId: Int)

	func hideActivityIndicator()

	func hideFooterActivityIndicator()

	func setSearchController(text: String)
}

final class SearchRepositoriesViewController: ASDKViewController<ASTableNode> {

	var interactor: SearchRepositoriesInteractorProtocol?

	// MARK: - Private properties

	private var searchControllerText: String = ""

	private lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: .large)
		activityIndicator.frame = node.frame
		activityIndicator.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
		return activityIndicator
	}()

	private lazy var footerLoader: UIActivityIndicatorView = {
		let footerLoader = UIActivityIndicatorView(style: .medium)
		let footerLoaderSize = CGSize(width: node.bounds.width, height: CGFloat(44))
		footerLoader.frame = CGRect(origin: .zero, size: footerLoaderSize)
		return footerLoader
	}()

	private(set) var repositories: [RepositoryNodeItem] = []

	// MARK: - Init

	override init() {
		super.init(node: ASTableNode())
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		node.view.tableFooterView = footerLoader
		navigationController?.view.addSubview(activityIndicator)
		configureNavigationBar()
		node.dataSource = self
		node.delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
	}
}

// MARK: - SearchRepositoriesViewControllerProtocol

extension SearchRepositoriesViewController: SearchRepositoriesViewControllerProtocol {

	func reloadTable(with newRepositories: [RepositoryNodeItem]) {
		repositories = newRepositories
		node.reloadData()
		node.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
	}

	func insert(newRepositories: [RepositoryNodeItem]) {
		let totalCount = repositories.count + newRepositories.count
		var indexPaths: [IndexPath] = []
		for row in repositories.count..<totalCount {
			let path = IndexPath(row: row, section: 0)
			indexPaths.append(path)
		}

		footerLoader.stopAnimating()
		repositories.append(contentsOf: newRepositories)
		node.insertRows(at: indexPaths, with: .fade)
	}

	func setFirstReadmeImage(by url: URL, for repositoryId: Int) {
		guard let safeRepositoryModel = repositories.first(where: { repositoryModel in
			repositoryModel.repositoryId == repositoryId
		}) else { return }
		safeRepositoryModel.repositoryNode.setFirstImageFromReadme(by: url)
	}

	func hideActivityIndicator() {
		activityIndicator.stopAnimating()
	}

	func hideFooterActivityIndicator() {
		footerLoader.stopAnimating()
	}

	func setSearchController(text: String) {
		navigationItem.searchController?.searchBar.text = text
	}
}

// MARK: - ASTableDataSource

extension SearchRepositoriesViewController: ASTableDataSource {

	func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
		repositories.count
	}

	func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
		let repository = repositories[indexPath.row]

		if let safeRepositoryId = repository.repositoryId,
		   let safeUserLogin = repository.userLogin,
		   let safeRepositoryName = repository.repositoryName {
			interactor?.extractReadme(repositoryId: safeRepositoryId,
									  ownerName: safeUserLogin,
									  repositoryName: safeRepositoryName)
		}

		let nodeBlock: ASCellNodeBlock = {
			return repository.repositoryNode
		}
		return nodeBlock
	}
}

// MARK: - ASTableDelegate

extension SearchRepositoriesViewController: ASTableDelegate {

	func shouldBatchFetchForCollectionNode(collectionNode: ASCollectionNode) -> Bool {
		return true
	}

	func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
		Task { @MainActor in self.footerLoader.startAnimating() }
		interactor?.getRepositories(by: searchControllerText, context: context)
	}

	func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
		guard let index = tableNode.indexPathForSelectedRow else { return }
		interactor?.processTap(on: repositories[indexPath.row])
		tableNode.deselectRow(at: index, animated: true)
	}
}

// MARK: - UITextFieldDelegate

extension SearchRepositoriesViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let safeText = textField.text else { return true }
		searchControllerText = safeText
		footerLoader.startAnimating()
		activityIndicator.startAnimating()
		interactor?.getRepositories(by: safeText, context: nil)
		navigationItem.searchController?.searchBar.setShowsCancelButton(false, animated: true)
		return true
	}
}

// MARK: - Private methods

private extension SearchRepositoriesViewController {

	func configureNavigationBar() {
		let search = UISearchController(searchResultsController: nil)
		search.obscuresBackgroundDuringPresentation = false
		search.searchBar.searchTextField.delegate = self
		navigationItem.hidesBackButton = true
		navigationItem.searchController = search
		let logoutBarButton = UIBarButtonItem(title: Strings.logout,
											  style: .done, target: self,
											  action: #selector(logoutButtonDidTap))
		navigationItem.setRightBarButton(logoutBarButton, animated: true)
		title = Strings.repositories
	}

	@objc func logoutButtonDidTap() {
		interactor?.logout()
	}
}
