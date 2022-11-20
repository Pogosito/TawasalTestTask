//
//  NSAttributedString+Extension.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 30.10.2022.
//

import UIKit

extension NSAttributedString {

	static func attributedString(string: String?,
								 fontSize size: CGFloat,
								 isBold: Bool = false,
								 color: UIColor = UIColor.black) -> NSAttributedString? {
		guard let string = string else { return nil }

		let font = isBold
		? UIFont.boldSystemFont(ofSize: size)
		: UIFont.systemFont(ofSize: size)

		let attributes = [NSAttributedString.Key.foregroundColor: color,
						  NSAttributedString.Key.font: font]

		let attributedString = NSMutableAttributedString(
			string: string,
			attributes: attributes
		)

		return attributedString
	}
}
