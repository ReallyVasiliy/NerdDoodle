//
//  MainViewController.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation
import UIKit
import SwiftyDraw
import MaLiang
import SpriteKit
import Kingfisher
import SwiftIconFont

protocol MainViewControllerDelegate: class {
    func didFinish()
}

class MainViewController: UIViewController {
    weak var delegate: MainViewControllerDelegate?
    var presenter: MainPresenter!
    
    @IBOutlet weak var debugImage: UIImageView!
    @IBOutlet weak var debugImage2: UIImageView!
    @IBOutlet weak var drawView: SwiftyDrawView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var instructionLabel2: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var metalCanvas: PassthroughCanvas!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    weak var nextTextLabel: UILabel?
    
    private weak var drawHost: SKNode?
    private weak var drawEmitter: SKEmitterNode?
    private weak var emitterScene: SKScene?
    
    private var drawEmitterBirthRate: CGFloat = 0
    private var timer: Timer?
    private var currentBackgroundIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalCanvas.target = drawView
        metalCanvas.touchDelegate = self
        
        presenter!.attach(self)
        
        backButton.parseIcon()
        clearButton.parseIcon()
    }
    
    func initSpriteKit() {
        if drawHost != nil {
            return
        }
        
        // Particles init
        let hostView = metalCanvas!
        let sk: SKView = SKView()
        sk.frame = hostView.frame
        sk.backgroundColor = .clear
        hostView.addSubview(sk)
        
        let scene: SKScene = SKScene(size: sk.bounds.size)
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .clear
        
        let drawNode = SKNode()
        let en = SKEmitterNode(fileNamed: "DrawParticleFireflies.sks")
        
        if let en = en {
            self.drawEmitter = en
            self.drawHost = drawNode
            drawNode.position = sk.center
            en.targetNode = scene
            drawNode.addChild(en)
            scene.addChild(drawNode)
            sk.presentScene(scene)
            
            drawEmitterBirthRate = en.particleBirthRate
            en.particleBirthRate = 0
        }
        
        self.emitterScene = scene
    }
    
    private func scheduleImageRotateTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(MainViewController.swapBackground), userInfo: nil, repeats: true)
    }
    
    private var backgroundImages: [String] = []
        
    func selectBackground(index: Int, immediate: Bool = false) {
        if index < 0 || index >= backgroundImages.count {
            return
        }
        let url = URL(string: backgroundImages[index])
        let duration: TimeInterval = immediate ? 0.25 : 2.5
        backgroundImage.kf.setImage(with: url,
                                    options: [
                                        .transition(.fade(duration)),
                                        .forceTransition,
                                        .keepCurrentImageWhileLoading
            ])
        
        if immediate {
            backgroundImage.animateImageDim()
        }
    }
    
    
    @objc
    func swapBackground() {
        currentBackgroundIndex += 1
        if currentBackgroundIndex >= backgroundImages.count {
            currentBackgroundIndex = 0
        }
        selectBackground(index: currentBackgroundIndex)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        drawView.backgroundColor = .black
        drawView.brush.color = .white
        let width = drawView.bounds.width
        let stroke = width * 0.04
        drawView.brush.width = stroke
        
        do {
            let texture = try metalCanvas.makeTexture(with: UIImage(named: "glow")!.pngData()!)
            let glow: GlowingBrush = try metalCanvas.registerBrush(name: "glow", textureID: texture.id)
            glow.opacity = 0.05
            glow.coreProportion = 0.2
            glow.pointSize = width * 0.1
            glow.rotation = .ahead
            glow.pointStep = 2
            glow.forceSensitive = 0.5
            glow.forceOnTap = 0.2
            glow.color = UIColor(rgb: 0xFF00A0)
            glow.use()
        } catch let error {
            log.error("Error while creating MaLiang brush: \(error)")
        }
        
        initSpriteKit()
    }
    
    private func registerBrush(with imageName: String) throws -> MaLiang.Brush {
        let texture = try metalCanvas.makeTexture(with: UIImage(named: imageName)!.pngData()!)
        return try metalCanvas.registerBrush(name: imageName, textureID: texture.id)
    }
    
    deinit {
        presenter?.detach()
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        (sender as! UIView).animateQuickTap(completion: { _ in
        })
        
        let alertView = UIAlertController(title: "Are you sure you want to exit?", message: "You will lose any progress.", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Exit", style: .destructive) { [weak self] _ in
            self?.delegate?.didFinish()
        })
        alertView.addAction(UIAlertAction(title: "Keep drawing", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func didTapClear(_ sender: Any) {
        (sender as! UIView).animateQuickTap(completion: { finish in
        })
        clear()
    }
    
    func clear() {
        metalCanvas.clear()
        drawView.clear()
        debugImage.image = nil
        debugImage2.image = nil
    }
}

extension MainViewController: TouchDelegate {
    func onTouchesBegan(touch: DrawTouch) {
        drawEmitter?.particleBirthRate = drawEmitterBirthRate
    }
    
    func onTouchesEnded() {
        drawEmitter?.particleBirthRate = 0
        presenter?.processImage(image: drawView)
    }
    
    func onTouchesMoved(touch: DrawTouch) {
        if let host = drawHost {
            // Y is flipped, because Y coordinate originates at bottom in SpriteKit, but not UIKit
            host.position = CGPoint(x: touch.point.x, y: metalCanvas.frame.maxY - touch.point.y)
        }
    }
}

// Text animation
extension MainViewController {
    private func dropIn(text: String?) {
        if nextTextLabel == nil {
            nextTextLabel = instructionLabel
        } else if nextTextLabel == instructionLabel {
            nextTextLabel = instructionLabel2
            instructionLabel.animateFadeOut()
        } else if nextTextLabel == instructionLabel2 {
            nextTextLabel = instructionLabel
            instructionLabel2.animateFadeOut()
        }
        
        nextTextLabel?.text = text
        nextTextLabel?.animateDropIn(toX: 0, toY: 100, duration: 1.2, delay: 0)
    }
    
    private func popPrediction(score: Double) {
        predictionLabel.text = String(format: "I'm %.0f%% sure", score * 100.0)
        let maxHue = 0.33
        let hue = maxHue * score
        predictionLabel.textColor = UIColor(hue: CGFloat(hue), saturation: 0.7, brightness: 1.0, alpha: 1.0)
        predictionLabel.animatePopInPrediction()
    }
}

extension MainViewController: MainView {

    #if DEBUG
    func showDebugImages(image1: UIImage?, image2: UIImage?) {
        debugImage.isHidden = false
        debugImage2.isHidden = false 
        debugImage.image = image1
        debugImage2.image = image2
        debugImage.alpha = 0.2
        debugImage2.alpha = 0.2
    }
    #endif
    
    
    static func scoreToEmoji(score: Double) -> Character {
        let icons = Constants.confidenceIcons
        let length = icons.count
        
        var index = Int(Double(length) * (1.0 - score))
        
        // Clamp
        if index < 0 {
            index = 0
        } else if index >= length {
            index = length - 1
        }
        
        return icons[icons.index(icons.startIndex, offsetBy: index)]
    }
    
    func loadBackgroundImages(_ images: [String]) {
        backgroundImages = images
        currentBackgroundIndex = 0
        selectBackground(index: currentBackgroundIndex, immediate: true)
        scheduleImageRotateTimer()
    }
    
    func showPrediction(text: String, score: Double) {
        popPrediction(score: score)
        dropIn(text: text)
    }    
}
