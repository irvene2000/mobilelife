//
//  Image.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 29/12/2022.
//

import Foundation
import SwiftyJSON

struct Picture: Codable {
    var author: String
    var downloadURL: URLType
    var height: Int
    var id: String
    var url: URLType
    var width: Int
    var image: UIImage?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decode(String.self, forKey: .author)
        self.downloadURL = try container.decode(URLType.self, forKey: .downloadURL)
        self.height = try container.decode(Int.self, forKey: .height)
        self.id = try container.decode(String.self, forKey: .id)
        self.url = try container.decode(URLType.self, forKey: .url)
        self.width = try container.decode(Int.self, forKey: .width)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.author, forKey: .author)
        try container.encode(self.downloadURL, forKey: .downloadURL)
        try container.encode(self.height, forKey: .height)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.url, forKey: .url)
        try container.encode(self.width, forKey: .width)
    }
    
    enum CodingKeys: String, CodingKey {
        case author
        case downloadURL = "download_url"
        case height
        case id
        case url
        case width
    }
}
