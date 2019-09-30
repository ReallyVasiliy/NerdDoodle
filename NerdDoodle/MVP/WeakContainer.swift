//
//  WeakContainer.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation

struct WeakContainer<T> {
    private weak var _value:AnyObject?
    
    init(_ value: T) {
        _value = value as AnyObject
    }
    
    var value: T? {
        get {
            return _value as? T
        }
        set {
            _value = newValue as AnyObject
        }
    }
}
