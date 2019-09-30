//
//  Prediction.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/30/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation

struct Prediction {
    let name: String
    let score: Double
}

extension DrawnImageClassifierOutput {
    func topPredictions(count: Int?, blacklist: [String]) -> [Prediction] {
        
        let sorted = category_softmax_scores
            .sorted { $0.value > $1.value }
            .filter { !blacklist.contains($0.key) }
        
        let top = (count != nil) ? Array(sorted.prefix(count!)) : sorted
        let predictions = top.map { Prediction(name: $0.key, score: $0.value) }
        
        return predictions
    }
    
    func predictions(withScoreAbove: Double, count: Int?) -> [Prediction] {
        let sorted = category_softmax_scores.filter { $0.value > withScoreAbove }.sorted { $0.value > $1.value }
        let top = (count != nil) ? Array(sorted.prefix(count!)) : sorted
        let predictions = top.map { Prediction(name: $0.key, score: $0.value) }
        return predictions
    }
}
