//
//  PhotoInfo.swift
//  AlamofireTest1
//
//  Created by Александр on 29.03.2020.
//  Copyright © 2020 Badmaev. All rights reserved.
//

import Foundation

struct PhotoInfo: Decodable {
    var author: String
    var width: Int
    var height: Int
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case author
        case width
        case height
        case url = "download_url"
    }
}
