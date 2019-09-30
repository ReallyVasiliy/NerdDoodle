//
//  ImageSearchService.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 9/29/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation

protocol ImageSearchService {
    func search(query: String, completion result: @escaping (ImageSearchResponse?, Error?) -> Void)
}
