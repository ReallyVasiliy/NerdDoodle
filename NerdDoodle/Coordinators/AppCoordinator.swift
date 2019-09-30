//
//  AppCoordinator.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import RxSwift

class AppCoordinator: Coordinator {
    let window: UIWindow
    let container: Container
    let navController: UINavigationController
    
    let settingsCoordinator: SettingsCoordinator
    let mainCoordinator: MainCoordinator
    
    init(window: UIWindow, container: Container) {
        navController = UINavigationController()
        navController.isNavigationBarHidden = true
        
        self.window = window
        self.window.rootViewController = navController
        self.window.makeKeyAndVisible()
        
        self.container = container
        
        settingsCoordinator = SettingsCoordinator(navController: navController, container: container)
        mainCoordinator = MainCoordinator(navController: navController, container: container)
    }
    
    func start() {
        let vc = container.resolve(MenuViewController.self)!
        vc.delegate = self
        navController.setViewControllers([vc], animated: false)
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func mainCoordinatorDone() {
        start()
    }
}

extension AppCoordinator: SettingsCoordinatorDelegate {
    func settingsCoordinatorSaved() {
        start()
    }
}

extension AppCoordinator: MenuViewControllerDelegate {
    func didSelectOpenApp() {
        mainCoordinator.delegate = self
        mainCoordinator.start()
    }
    
    func didSelectSettings() {
        settingsCoordinator.delegate = self
        settingsCoordinator.start()
    }
}
