//
//  MainCoordinator.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//
import Foundation
import Swinject

protocol MainCoordinatorDelegate : class {
    func mainCoordinatorDone()
}

class MainCoordinator: BaseCoordinator {
    weak var delegate: MainCoordinatorDelegate?
    
    override func start() {
        let vc = self.container.resolve(MainViewController.self)!
        vc.delegate = self
        self.transitionView(to: vc)
    }
}

extension MainCoordinator: MainViewControllerDelegate {
    func didFinish() {
        self.delegate!.mainCoordinatorDone()
    }
}
