//
//  RepositoryDetailedInformationVC.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 08.11.2022.
//

import AsyncDisplayKit

final class RepositoryDetailedInformationVC: ASDKViewController<ASTableNode> {

	// MARK: - Private properties

	private let repositoryModel: GitHubRepositoryItem

	private lazy var nodes = [
		IconTextAndSecondaryTextNode(icon: UIImage(named: "issues") ?? .checkmark,
									 text: "Issues", secondaryText: String(repositoryModel.openIssuesCount ?? 0)),
		IconTextAndSecondaryTextNode(icon: UIImage(named: "watchers") ?? .checkmark,
									 text: "Watchers", secondaryText: String(repositoryModel.watchersCount ?? 0)),
		IconTextAndSecondaryTextNode(icon: UIImage(named: "forks") ?? .checkmark,
									 text: "Forks count", secondaryText: String(repositoryModel.forksCount ?? 0)),
		IconTextAndSecondaryTextNode(icon: UIImage(named: "filesize") ?? .checkmark,
									 text: "Size", secondaryText: String(repositoryModel.size ?? 0) + " KB"),
		IconTextAndSecondaryTextNode(icon: UIImage(named: "calendar") ?? .checkmark,
									 text: "Created at", secondaryText: repositoryModel.formattedDate())
	]

	// MARK: - Init

	init(repositoryModel: GitHubRepositoryItem) {
		self.repositoryModel = repositoryModel
		super.init(node: ASTableNode())
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Info"
		node.dataSource = self
		node.delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}
}

// MARK: - ASTableDataSource

extension RepositoryDetailedInformationVC: ASTableDataSource {

	func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int { 5 }

	func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
		let node = self.nodes[indexPath.row]
		let nodeBlock: ASCellNodeBlock = { node }

//		switch indexPath.row {
//		case 0: nodeBlock = { self.nodes[0] }
//		case 1: nodeBlock = { self.nodes[1] }
//		case 2: nodeBlock = { self.nodes[2] }
//		case 3: nodeBlock = { self.nodes[3] }
//		case 4: nodeBlock = { self.nodes[4] }
//		default: nodeBlock = { ASCellNode() }
//		}

		return nodeBlock
	}
}

// MARK: - ASTableDelegate

extension RepositoryDetailedInformationVC: ASTableDelegate {

	func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
		guard let index = tableNode.indexPathForSelectedRow else { return }
		tableNode.deselectRow(at: index, animated: true)
	}
}
