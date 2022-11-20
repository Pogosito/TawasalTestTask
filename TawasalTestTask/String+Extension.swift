//
//  String+Extension.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 09.11.2022.
//

import Foundation

extension String {

	func getFirstImageUrlByMarkdownPattern() -> URL? {
		guard let firstMarkdownImage = getSubstring(by: "!\\[[^\\]]*\\]\\((.*?)\\s*(\"(?:.*[^\"])\")?\\s*\\)",
													for: self) else { return nil }
		let markdownImageUrlString = firstMarkdownImage.getSubstring(by: "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)", for: firstMarkdownImage)

		guard let safeMarkdownImageUrlString = markdownImageUrlString else { return nil }
		return URL(string: safeMarkdownImageUrlString)
	}

	private func getSubstring(by regexPattern: String, for string: String) -> String? {
		guard let regex = try? NSRegularExpression(pattern: regexPattern) else { return nil }
		guard let checkingResult = regex.firstMatch(in: string, range: NSMakeRange(0, string.count)) else { return nil }
		let matchedString = (string as NSString).substring(with: checkingResult.range)
		return matchedString
	}
}
