//
//  MvpPresenter.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation

protocol MvpPresenter {
    associatedtype MvpView
    
    func attach(_ view: MvpView)
    func detach()
    func getView() -> MvpView?
    func isAttached() -> Bool
    
}
