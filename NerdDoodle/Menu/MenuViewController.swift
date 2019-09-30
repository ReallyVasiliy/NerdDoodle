//
//  MenuViewController.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation
import UIKit

protocol MenuViewControllerDelegate: class {
    func didSelectOpenApp()
    func didSelectSettings()
}

class MenuViewController: UIViewController {
    weak var delegate: MenuViewControllerDelegate?
    
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.onLogoTapped))
        logoImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func onLogoTapped() {
        logoImage?.animateBounce()
    }
    
    @IBAction func startTapped(_ sender: Any) {
        (sender as! UIView).animateLargeTap(completion: { [weak self] finish in
            self?.delegate?.didSelectOpenApp()
        })
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        self.delegate?.didSelectSettings()
    }
}
