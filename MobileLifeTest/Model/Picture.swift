//
//  Image.swift
//  MobileLifeTest
//
//  Created by Tan Way Loon on 29/12/2022.
//

import Foundation
import SwiftyJSON

public enum PictureVariant: Hashable, Identifiable {
    public var id: Self {
        return self
    }
    
    case normal
    case blur(index: Int)
    case grayscale
}

public struct Picture: Codable {
    var author: String
    var downloadURL: URLType
    var height: Int
    var id: String
    var url: URLType
    var width: Int
    var imageCache: [PictureVariant: UIImage]
    
    public init(author: String, downloadURL: URLType, height: Int, id: String, url: URLType, width: Int, imageCache: [PictureVariant: UIImage]) {
        self.author = author
        self.downloadURL = downloadURL
        self.height = height
        self.id = id
        self.url = url
        self.width = width
        self.imageCache = imageCache
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decode(String.self, forKey: .author)
        self.downloadURL = try container.decode(URLType.self, forKey: .downloadURL)
        self.height = try container.decode(Int.self, forKey: .height)
        self.id = try container.decode(String.self, forKey: .id)
        self.url = try container.decode(URLType.self, forKey: .url)
        self.width = try container.decode(Int.self, forKey: .width)
        self.imageCache = [:]
    }
    
    public func encode(to encoder: Encoder) throws {
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
        case imageCache
    }
}

extension Picture {
    func imageSizeFittingInScreen(scale: CGFloat = 1.0) -> CGSize {
        let actualPictureSize = CGSize(width: width, height: height)
        return actualPictureSize.fittingInScreen(scale: scale)
    }
}
