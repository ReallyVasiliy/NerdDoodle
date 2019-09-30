//
//  SettingsPresenter.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation

protocol SettingsView: MvpView {
    // If we had settings, we'd add some in here at some point...
}

class SettingsPresenter: BasePresenter<SettingsView> {
    override func attach(_ view: SettingsView) {
        // Do something
    }
}
