//
//  ImageSearchResponse.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 9/15/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation

public struct ImageSearchResponse: Codable {
    let hits: [ImageHit]
}

public struct ImageHit: Codable {
    let largeImageURL: String
}
