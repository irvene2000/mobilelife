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
    
    enum CodingKeys: String, CodingKey {
        case author
        case downloadURL = "download_url"
        case height
        case id
        case url
        case width
    }
}
