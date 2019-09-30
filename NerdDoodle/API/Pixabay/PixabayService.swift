//
//  PixabayService.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 9/15/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class PixabayService {
    static let baseUrl: String = "https://pixabay.com/api/"
    
    fileprivate var pixabayApiKey: String {
        // TODO: Provide your API key
        return "[YOUR PIXABAY API KEY]"
    }
}

extension PixabayService: ImageSearchService {
    func search(query: String, completion result: @escaping (ImageSearchResponse?, Error?) -> Void) {
        let parameters: Parameters = [
            "key": pixabayApiKey,
            "q": query,
            "orientation": "vertical",
            "safesearch": true,
            "per_page": 4,
            "image_type": "photo"
        ]
        
        AF.request(PixabayService.baseUrl, method: .get, parameters: parameters)
            .responseDecodable(of: ImageSearchResponse.self) { response in
                result(response.value, response.error)
        }
    }
}
