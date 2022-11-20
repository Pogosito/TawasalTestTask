//
//  IconTextAndSecondaryTextNode.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 08.11.2022.
//

import AsyncDisplayKit

final class IconTextAndSecondaryTextNode: ASCellNode {

	// MARK: - Private properties

	private let icon = ASImageNode()
	private let text = ASTextNode()
	private let secondaryText = ASTextNode()

	// MARK: - Init

	init(icon: UIImage, text: String, secondaryText: String) {
		super.init()
		automaticallyManagesSubnodes = true
		self.icon.image = icon
		self.icon.style.preferredSize = CGSize(width: 24, height: 24)
		self.text.attributedText = NSAttributedString.attributedString(
			string: text,
			fontSize: 20
		)

		self.secondaryText.attributedText = NSAttributedString.attributedString(
			string: secondaryText,
			fontSize: 20,
			color: UIColor.gray
		)
	}

	// MARK: - ASDisplayNode

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

		let iconTextStack = ASStackLayoutSpec(direction: .horizontal,
											  spacing: 7,
											  justifyContent: .center,
											  alignItems: .center, children: [icon, text])

		let mainStack = ASStackLayoutSpec(direction: .horizontal,
										  spacing: 8,
										  justifyContent: .spaceBetween,
										  alignItems: .start, children: [
											iconTextStack,
											secondaryText
		])

		return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), child: mainStack)
	}
}
