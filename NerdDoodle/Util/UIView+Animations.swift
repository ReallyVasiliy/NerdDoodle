//
//  AnimationUtils.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/28/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import UIKit

extension UIView {
    public func animateLargeTap(completion: @escaping (Bool) -> Void) {
        self.transform = CGAffineTransform(scaleX: 0.50, y: 0.80)
        UIView.animate(withDuration: 0.65,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.5,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.transform = .identity
            },
                       completion: { finish in
                        completion(finish)
        })
    }
    
    public func animateBounce() {
        self.transform = .identity
        UIView.animate(withDuration: 0.65,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.5,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.transform = CGAffineTransform(translationX: 0.0, y: 100.0)
            },
                       completion: { [weak self] finished in
                        
                        UIView.animate(withDuration: 2.65,
                                       delay: 0,
                                       usingSpringWithDamping: 0.5,
                                       initialSpringVelocity: 0.5,
                                       options: .allowUserInteraction,
                                       animations: { [weak self] in
                                        self?.transform = .identity
                            },
                                       completion: nil)
        })
    }
    
    public func animateQuickTap(completion: @escaping (Bool) -> Void) {
        self.transform = CGAffineTransform(scaleX: 0.80, y: 0.67)
        UIView.animate(withDuration: 0.65,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.5,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.transform = .identity
            },
                       completion: { finish in
                        completion(finish)
        })
    }
    
    public func animateDropIn(toX: CGFloat, toY: CGFloat, duration: TimeInterval, delay: TimeInterval = 0, completion: ((Bool) -> ())? = nil) {
        self.alpha = 0.0
        self.transform = .identity
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.25,
                       options: .curveEaseIn,
                       animations: { [weak self] in
                        self?.transform = CGAffineTransform(translationX: toX, y: toY)
            },
                       completion: { finish in
                        completion?(finish)
        })
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        self?.alpha = 1.0
            },
                       completion: nil)
    }
    
    public func animateFadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
            self?.alpha = 0.0
        })
    }
    
    public func animateImageDim() {
        self.alpha = 0.8
        UIView.animate(withDuration: 3.25, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
            self?.alpha = 0.4
        })
    }
    
    public func animatePopInPrediction() {
        self.alpha = 0.0
        UIView.animate(withDuration: 0.45, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
            self?.alpha = 1.0
            }, completion: { [weak self] finished in
                if finished {
                    UIView.animate(withDuration: 3.45, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
                        self?.alpha = 0.4
                    })
                }
        })
    }
}
