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
		IconTextAndSecondaryTextNode(icon: UIImage(named: SemanticAssets.issues) ?? .checkmark,
									 text: Strings.issues, secondaryText: String(repositoryModel.openIssuesCount ?? 0)),
		IconTextAndSecondaryTextNode(icon: UIImage(named: SemanticAssets.watchers) ?? .checkmark,
									 text: Strings.watchers, secondaryText: String(repositoryModel.watchersCount ?? 0)),
		IconTextAndSecondaryTextNode(icon: UIImage(named: SemanticAssets.fork) ?? .checkmark,
									 text: Strings.forksCount, secondaryText: String(repositoryModel.forksCount ?? 0)),
		IconTextAndSecondaryTextNode(icon: UIImage(named: SemanticAssets.filesize) ?? .checkmark,
									 text: Strings.size, secondaryText: String(repositoryModel.size ?? 0) + " \(Strings.KB)"),
		IconTextAndSecondaryTextNode(icon: UIImage(named: SemanticAssets.calendar) ?? .checkmark,
									 text: Strings.createdAt, secondaryText: repositoryModel.formattedDate())
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
		title = repositoryModel.fullName
		node.dataSource = self
		node.delegate = self
	}
}

// MARK: - ASTableDataSource

extension RepositoryDetailedInformationVC: ASTableDataSource {

	func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int { nodes.count }

	func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
		let node = self.nodes[indexPath.row]
		let nodeBlock: ASCellNodeBlock = { node }

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
