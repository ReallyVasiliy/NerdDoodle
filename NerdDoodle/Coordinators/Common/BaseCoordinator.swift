//
//  BaseCoordinator.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import RxSwift

class BaseCoordinator : NSObject, Coordinator {
    static let DEFAULT_SCREEN_TRANSITION_DURATION:CFTimeInterval = 0.3
    
    let disposeBag = DisposeBag()
    
    let container: Container
    let navController: UINavigationController
    
    init(navController: UINavigationController, container: Container) {
        self.navController = navController
        self.container = container
    }
    
    func start() {
    }
    
    func transitionView(to: UIViewController, addFade: Bool = false) {
        if addFade {
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            transition.type = CATransitionType.fade
            self.navController.view.layer.add(transition, forKey: kCATransition)
        }
        
        self.navController.setViewControllers([to], animated: false);
    }
}
