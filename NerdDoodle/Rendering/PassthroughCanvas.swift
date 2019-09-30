//
//  PassthroughCanvas.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/30/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import MaLiang
import RxSwift

protocol TouchDelegate: class {
    func onTouchesMoved(touch: DrawTouch)
    func onTouchesBegan(touch: DrawTouch)
    func onTouchesEnded()
}

public struct DrawTouch {
    
    var point: CGPoint
    var force: CGFloat
    
    init(touch: UITouch, on view: UIView) {
        if #available(iOS 9.1, *) {
            point = touch.preciseLocation(in: view)
        } else {
            point = touch.location(in: view)
        }
        force = touch.force
        
        // force on iPad from a finger is always 0, reset to 0.3
        if UIDevice.current.userInterfaceIdiom == .pad, touch.type == .direct, force == 0 {
            force = 1
        }
    }
    
    init(point: CGPoint, force: CGFloat) {
        self.point = point
        self.force = force
    }
}

class PassthroughCanvas: Canvas {
    public var target: UIView!
    public weak var touchDelegate: TouchDelegate?
    
    /// touchesBegan implementation to capture strokes
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        let dt = DrawTouch(touch: touch, on: self)
        touchDelegate?.onTouchesBegan(touch: dt)
        target.touchesBegan(touches, with: event)
    }
    
    /// touchesMoves implementation to capture strokes
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        let dt = DrawTouch(touch: touch, on: self)
        touchDelegate?.onTouchesMoved(touch: dt)
        target.touchesMoved(touches, with: event)
    }
    
    /// touchedEnded implementation to capture strokes
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        target.touchesEnded(touches, with: event)
        touchDelegate?.onTouchesEnded()
    }
    
    /// touchedCancelled implementation
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        target.touchesCancelled(touches, with: event)
    }
}
