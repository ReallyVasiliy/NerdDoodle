//
//  SettingsViewController.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation
import UIKit
import SwiftIconFont
import ActiveLabel

protocol SettingsViewControllerDelegate: class {
    func didSaveSettings()
}

class SettingsViewController: UIViewController {
    weak var delegate: SettingsViewControllerDelegate?
    var presenter: SettingsPresenter!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var authorLabel: ActiveLabel!
    @IBOutlet weak var credits1: ActiveLabel!
    @IBOutlet weak var credits2: ActiveLabel!
    @IBOutlet weak var credits3: ActiveLabel!
    @IBOutlet weak var credits4: ActiveLabel!
    
    @IBAction func saveTapped(_ sender: Any) {
        delegate?.didSaveSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorLabel.handleURLTap { [weak self] (url) in
            self?.open(url: url)
        }
        credits1.handleURLTap { [weak self] (url) in
            self?.open(url: url)
        }
        credits2.handleURLTap { [weak self] (url) in
            self?.open(url: url)
        }
        credits3.handleURLTap { [weak self] (url) in
            self?.open(url: url)
        }
        credits4.handleURLTap { [weak self] (url) in
            self?.open(url: url)
        }
        backButton.parseIcon()
    }
    
    private func open(url: URL) {
        UIApplication.shared.open(url)
    }
}
