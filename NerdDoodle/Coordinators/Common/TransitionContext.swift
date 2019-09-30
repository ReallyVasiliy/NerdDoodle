//
//  TransitionContext.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation
import RxSwift

protocol TransitionContext {
    func animateOut()
    
    func observeAnimateOutCompleted() -> Observable<Void>
    
    func animateIn()
    
    func observeAnimateInCompleted() -> Observable<Void>
}
