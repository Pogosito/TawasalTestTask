//
//  RepositoryNode.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 30.10.2022.
//

import AsyncDisplayKit

final class RepositoryNode: ASCellNode {

	// MARK: - Private properties

	private let userAvatar: ASNetworkImageNode = {
		let userAvatar = ASNetworkImageNode()
		userAvatar.contentMode = .scaleAspectFill
		userAvatar.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
		userAvatar.style.preferredSize = CGSize(width: 30, height: 30)
		return userAvatar
	}()

	private let userLogin = ASTextNode()
	private let repositoryName = ASTextNode()
	private let repositoryDescription = ASTextNode()
	private let starIcon = ASImageNode()
	private let numberOfStars = ASTextNode()
	private let languageName = ASTextNode()

	private(set) lazy var firstImageFromReadme: ASNetworkImageNode = {
		let firstImageFromReadme = ASNetworkImageNode()
		firstImageFromReadme.delegate = self
		firstImageFromReadme.contentMode = .scaleAspectFit
		return firstImageFromReadme
	}()

	private let langNode: ASTextNode = {
		let langNode = ASTextNode()
		langNode.attributedText = NSAttributedString.attributedString(
			string: Strings.lan,
			fontSize: 15,
			isBold: true,
			color: UIColor.darkGray
		)
		return langNode
	}()

	// MARK: - Init

	init(avatarUrl: String?,
		 userLogin: String?,
		 repositoryName: String?,
		 description: String?,
		 stars: Int?,
		 language: String?) {
		super.init()
		automaticallyManagesSubnodes = true
		userAvatar.url = URL(string: avatarUrl ?? "")
		self.userLogin.attributedText = NSAttributedString.attributedString(
			string: userLogin,
			fontSize: 14,
			color: UIColor.darkGray
		)

		self.repositoryName.attributedText = NSAttributedString.attributedString(
			string: repositoryName ?? "",
			fontSize: 15,
			isBold: true
		)

		repositoryDescription.attributedText = NSAttributedString.attributedString(
			string: description ?? "",
			fontSize: 15
		)

		starIcon.image = UIImage(named: SemanticAssets.star)
		starIcon.style.preferredSize = CGSize(width: 16, height: 16)

		numberOfStars.attributedText = NSAttributedString.attributedString(
			string: String(stars ?? 0),
			fontSize: 15,
			color: UIColor.gray
		)

		languageName.attributedText = NSAttributedString.attributedString(
			string: language ?? "",
			fontSize: 15,
			color: UIColor.gray
		)
	}
}

// MARK: - Public

extension RepositoryNode {

	func setFirstImageFromReadme(by url: URL) {
		firstImageFromReadme.url = url
	}
}

// MARK: - ASDisplayNode

extension RepositoryNode {

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

		let userStack = ASStackLayoutSpec(direction: .horizontal,
										  spacing: 7,
										  justifyContent: .start,
										  alignItems: .center, children: [userAvatar, userLogin])

		let starsStack = ASStackLayoutSpec(direction: .horizontal,
										   spacing: 5, justifyContent: .start,
										   alignItems: .start, children: [starIcon, numberOfStars])
		
		let languageStack = ASStackLayoutSpec(direction: .horizontal,
											  spacing: 2, justifyContent: .start,
											  alignItems: .center, children: [langNode, languageName])

		let starsAndLanguageStack = ASStackLayoutSpec(direction: .horizontal,
													  spacing: 12, justifyContent: .start,
													  alignItems: .start, children: languageName.attributedText?.string == ""
													  ? [starsStack]
													  : [starsStack, languageStack])

		let mainStack = ASStackLayoutSpec(direction: .vertical,
										 spacing: 8,
										 justifyContent: .start,
										 alignItems: .start, children: [
			userStack,
			repositoryName,
			repositoryDescription,
			starsAndLanguageStack,
			firstImageFromReadme
		])

		return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), child: mainStack)
	}
}

// MARK: - ASNetworkImageNodeDelegate

extension RepositoryNode: ASNetworkImageNodeDelegate {

	func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
		firstImageFromReadme.style.preferredSize = image.size
		firstImageFromReadme.style.maxHeight = ASDimensionMakeWithPoints(70)
		setNeedsLayout()
	}
}
