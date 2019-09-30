//
//  BasePresenter.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation
import RxSwift

class BasePresenter<MvpView> : MvpPresenter {
    typealias T = MvpView
    
    private var viewContainer : WeakContainer<T>?
    private let disposeBag = DisposeBag()
    
    init () {
    }
    
    func getDisposeBag() -> DisposeBag {
        return disposeBag
    }
    
    func attach(_ view: T) {
        self.viewContainer = WeakContainer(view)
    }
    
    func detach() {
        self.viewContainer = nil
    }
    
    func getView() -> T? {
        return self.viewContainer?.value
    }
    
    func isAttached() -> Bool {
        return self.viewContainer?.value != nil
    }
}
