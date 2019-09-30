//
//  SettingsCoordinator.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation
import Swinject

protocol SettingsCoordinatorDelegate : class {
    func settingsCoordinatorSaved()
}

class SettingsCoordinator: BaseCoordinator {
    weak var delegate: SettingsCoordinatorDelegate?
    
    override func start() {
        let vc = self.container.resolve(SettingsViewController.self)!
        vc.delegate = self
        self.transitionView(to: vc)
    }
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
    func didSaveSettings() {
        self.delegate!.settingsCoordinatorSaved()
    }
}
