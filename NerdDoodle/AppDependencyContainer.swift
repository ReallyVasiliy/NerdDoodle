//
//  AppDependencyContainer.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation
import Swinject

class AppDependencyContainer {
    static func create() -> Container {
        
        let container = Container()
        
        // MARK: Menu
        container.register(MenuViewController.self) { r in
            MenuViewController()
        }
        
        // MARK: Main
        container.register(MainViewController.self) { r in
            let vc = MainViewController()
            vc.presenter = r.resolve(MainPresenter.self)!
            return vc
        }
        container.register(MainPresenter.self) { r in
            MainPresenter(imageSearchService: r.resolve(ImageSearchService.self)!)
        }
        
        // MARK: Settings
        container.register(SettingsViewController.self) { r in
            let vc = SettingsViewController()
            vc.presenter = r.resolve(SettingsPresenter.self)!
            return vc
        }
        container.register(SettingsPresenter.self) { _ in
            SettingsPresenter()
        }
        
        // MARK: Services
        container.register(ImageSearchService.self) { _ in
            PixabayService()
        }
        
        
        return container
    }
}

