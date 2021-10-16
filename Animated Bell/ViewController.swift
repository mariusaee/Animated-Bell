//
//  ViewController.swift
//  Animated Bell
//
//  Created by Marius Malyshev on 15.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bellView: UIImageView!
    @IBOutlet weak var bellsAssView: UIView!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var angleSlider: UISlider!
    @IBOutlet weak var offsetSlider: UISlider!
    @IBOutlet weak var rotationSlider: UISlider!
    
    
    var duration: Double = 1 {
        didSet { shakeWith(duration: duration, angle: angle, yOffset: yOffset) }
    }
    var angle: CGFloat = .pi/8 {
        didSet { shakeWith(duration: duration, angle: angle, yOffset: yOffset) }
    }
    var yOffset: CGFloat = 0.5 {
        didSet { shakeWith(duration: duration, angle: angle, yOffset: yOffset) }
    }
    var rotation: CGFloat = 1 {
        didSet {
            bellsAssView.transform = CGAffineTransform(rotationAngle: rotation)
            shakeWith(duration: duration, angle: angle, yOffset: yOffset)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func durationSliderChanged(_ sender: UISlider) {
        duration = Double(sender.value)*2
    }
    @IBAction func angleSliderChanged(_ sender: UISlider) {
        angle = CGFloat(sender.value) * .pi/2
    }
    @IBAction func offsetSliderChanged(_ sender: UISlider) {
        yOffset = CGFloat(sender.value)
    }
    @IBAction func rotationSliderChanged(_ sender: UISlider) {
        rotation = CGFloat(sender.value)
    }
    
}

// MARK: - Setup
extension ViewController {
    func setup() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_: )))
        bellView.addGestureRecognizer(singleTap)
        bellView.isUserInteractionEnabled = true
    }
}


// MARK: - Animation
extension ViewController {
    @objc func imageViewTapped(_ recognizer: UITapGestureRecognizer) {
        shakeWith(duration: duration, angle: angle, yOffset: yOffset)
    }
    
    private func shakeWith(duration: Double, angle: CGFloat, yOffset: CGFloat) {
        print("duration: \(duration) angle: \(angle) offset: \(yOffset)")
        
        let numberOfFrames: Double = 6
        let frameDuration = Double(1/numberOfFrames)
        
        bellView.setAnchorPoint(CGPoint(x: 0.5, y: yOffset))
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: [],
            animations:{
                UIView.addKeyframe(withRelativeStartTime: 0.0,
                                   relativeDuration: frameDuration) {
                    self.bellView.transform = CGAffineTransform(rotationAngle: -angle)
                }
                
                UIView.addKeyframe(withRelativeStartTime: frameDuration,
                                   relativeDuration: frameDuration) {
                    self.bellView.transform = CGAffineTransform(rotationAngle: +angle)
                }
                
                UIView.addKeyframe(withRelativeStartTime: frameDuration*2,
                                   relativeDuration: frameDuration) {
                    self.bellView.transform = CGAffineTransform(rotationAngle: -angle)
                }
                
                UIView.addKeyframe(withRelativeStartTime: frameDuration*3,
                                   relativeDuration: frameDuration) {
                    self.bellView.transform = CGAffineTransform(rotationAngle: +angle)
                }
                
                UIView.addKeyframe(withRelativeStartTime: frameDuration*4,
                                   relativeDuration: frameDuration) {
                    self.bellView.transform = CGAffineTransform(rotationAngle: -angle)
                }
                
                UIView.addKeyframe(withRelativeStartTime: frameDuration*5,
                                   relativeDuration: frameDuration) {
                    self.bellView.transform = CGAffineTransform.identity
                }
            }
        )
    }
}

extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(
            x: bounds.size.width * point.x,
            y: bounds.size.height * point.y
        )
        var oldPoint = CGPoint(
            x: bounds.size.width * layer.anchorPoint.x,
            y: bounds.size.height * layer.anchorPoint.y
        )
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
}
