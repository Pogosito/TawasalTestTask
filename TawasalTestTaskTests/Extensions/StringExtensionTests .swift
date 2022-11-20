//
//  StringExtensionTests.swift
//  TawasalTestTaskTests
//
//  Created by Pogos Anesyan on 09.11.2022.
//

import XCTest
@testable import TawasalTestTask

final class StringExtensionTests: XCTestCase {

	func testGetFirstImageUrlByMarkdownPatternFindUrl() {

		// arrange
		let markdownString = """
			## Coming from AsyncDisplayKit? Learn more [here](https://medium.com/@Pinterest_Engineering/introducing-texture-a-new-home-for-asyncdisplaykit-e7c003308f50)
			![Texture](https://github.com/texturegroup/texture/raw/master/docs/static/images/logo.png)

			[![Apps Using](https://img.shields.io/cocoapods/at/Texture.svg?label=Apps%20Using%20Texture&colorB=28B9FE)](http://cocoapods.org/pods/Texture)
			[![Downloads](https://img.shields.io/cocoapods/dt/Texture.svg?label=Total%20Downloads&colorB=28B9FE)](http://cocoapods.org/pods/Texture)
		"""
		let firstUrl = URL(string: "https://github.com/texturegroup/texture/raw/master/docs/static/images/logo.png")

		// act
		let foundedUrl = markdownString.getFirstImageUrlByMarkdownPattern()

		// assert
		XCTAssertEqual(firstUrl, foundedUrl)
	}

	func testGetFirstImageUrlByMarkdownPatternDontFindUrl() {

		// arrange
		let markdownString = """
			## Coming from AsyncDisplayKit? https://medium.com/@Pinterest_Engineering/introducing-texture-a-new-home-for-asyncdisplaykit-e7c003308f50)
			![Texture](https://github.com/texturegroup/texture/raw/master/docs/static/images/logo.png
			[]()
			[![Apps Using]https://img.shields.io/cocoapods/at/Texture.svg?label=Apps%20Using%20Texture&colorB=28B9FE)](http://cocoapods.org/pods/Texture
			[!Downloads(https://img.shields.io/cocoapods/dt/Texture.svg?label=Total%20Downloads&colorB=28B9FE)](http://cocoapods.org/pods/Texture)
		"""

		// assert
		XCTAssertEqual(nil, markdownString.getFirstImageUrlByMarkdownPattern()) 
	}
}
