//
//  GitHubReadmeModel.swift
//  TawasalTestTask
//
//  Created by Pogos Anesyan on 07.11.2022.
//

struct GitHubReadmeModel: Decodable {

	var downloadUrl: String

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		downloadUrl = try values.decode(String.self, forKey: .downloadUrl)
	}

	init(downloadUrl: String) {
		self.downloadUrl = downloadUrl
	}

	private enum CodingKeys: String, CodingKey {
		case downloadUrl = "download_url"
	}
}
