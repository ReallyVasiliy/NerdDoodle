//
//  MainPresenter.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import SwiftyDraw

protocol MainView {
    func showPrediction(text: String, score: Double)
    func loadBackgroundImages(_ images: [String])
    func showDebugImages(image1: UIImage?, image2: UIImage?)
}

class MainPresenter: BasePresenter<MainView> {
    #if DEBUG
    let debugImageSubject = PublishSubject<(UIImage?, UIImage?)>()
    #endif
    
    private let imageSubject = PublishSubject<SwiftyDrawView>()
    private let guessesSubject = PublishSubject<[Prediction]>()
    private let drawnImageClassifier = DrawnImageClassifier()
    private let imageScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    private let imageSearchService: ImageSearchService
    
    init(imageSearchService: ImageSearchService) {
        self.imageSearchService = imageSearchService
    }
    
    override func attach(_ view: MainView) {
        super.attach(view)
        
        #if DEBUG
        debugImageSubject
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] images in
                self?.getView()?.showDebugImages(image1: images.0, image2: images.1)
            })
            .disposed(by: getDisposeBag())
        #endif
        
        guessesSubject
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] output in
                if let top = output.first {
                    self?.handlePrediction(prediction: top)
                }
            })
            .disposed(by: getDisposeBag())
        
        imageSubject
            // Debounce quick drawing if we want to limit API calls or UI thread activity
//            .debounce(RxTimeInterval.milliseconds(2500), scheduler: imageScheduler)
            .observeOn(MainScheduler.instance)
            .map { drawView -> (CALayer, CGRect, CGRect?) in
                return (drawView.layer, drawView.frame, drawView.strokeBounds())
            }
            .observeOn(imageScheduler)
            .map { [weak self] layerFramePair -> UIImage in
                let screenshot = MainPresenter.screenshotBackground(layer: layerFramePair.0, size: layerFramePair.1.size)!
                var cropped = screenshot
                
                if let bounds = layerFramePair.2 {
                    cropped = screenshot.cropToBounds(bounds: bounds)
                }
                
                let resized = cropped.resize(newSize: CGSize(width: UIImage.PBUF_SIZE, height: UIImage.PBUF_SIZE))
                
                #if DEBUG
                self?.debugImageSubject.onNext((resized, nil))
                #endif
                
                return resized
            }
            .subscribe(onNext: { [weak self] resized in
                
                guard let pixelBuffer = resized.grayScalePixelBuffer() else {
                    print("couldn't create pixel buffer")
                    return
                }
                
                do {
                    if let prediction = try self?.drawnImageClassifier.prediction(image: pixelBuffer) {
                        self?.guessesSubject.onNext(prediction.topPredictions(count: 5, blacklist: ClassificationConstants.Ignore))
                    }
                }
                catch {
                    print("error making prediction: \(error)")
                }
            }, onError: { error in
                
            }, onCompleted: {
                
            }, onDisposed: {
                
            })
            .disposed(by: getDisposeBag())
    }
    
    func handlePrediction(prediction: Prediction) {
        let query: String = prediction.name
        let score = prediction.score
        let emoji = MainViewController.scoreToEmoji(score: score)
        let prefixed = MainPresenter.prefixSubject(toWord: query)
        let phrase = "\(prefixed.prefix(1).uppercased())\(prefixed.dropFirst()) \(emoji)"
        
        getView()?.showPrediction(text: phrase, score: score)
        
        imageSearchService.search(query: query) { [weak self] (response, error) in
            if let response = response {
                self?.getView()?.loadBackgroundImages(response.hits.map { $0.largeImageURL })
            }
        }
    }
    
    static func prefixSubject(toWord: String) -> String {
        let string = toWord.lowercased()
        let vowels: [Character] = ["a","e","i","o","u"]
        let theExceptions = ["moon", "sun"]
        if string.hasPrefix("the") {
            return toWord
        } else if theExceptions.contains(string) {
            return "the \(string)"
        } else if string.hasSuffix("s") {
            return toWord
        } else if let first = string.first {
            if vowels.contains(first) {
                return "an \(toWord)"
            } else {
                return "a \(toWord)"
            }
        }
        return toWord
    }
    
    static func screenshotBackground(layer: CALayer, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
    
    func processImage(image: SwiftyDrawView) {
        imageSubject.onNext(image)
    }
}
