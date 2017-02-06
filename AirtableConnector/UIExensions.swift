//
//  roundCornerButton.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/1.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
}

extension UIColor {
    
    var redValue: CGFloat{ return self.ciColor.red }
    var greenValue: CGFloat{ return self.ciColor.green }
    var blueValue: CGFloat{ return self.ciColor.blue }
    var alphaValue: CGFloat{ return self.ciColor.alpha }
    
}

extension UIView {
    
    func startRotating(duration: Double = 2, isClockwise: Bool) {
        let kAnimationKey = "rotation"
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            if isClockwise { animate.toValue = Float(M_PI * 2.0) }
            else { animate.toValue = Float(0.0 - M_PI * 2.0) }
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    func stopRotating() -> CATransform3D {
        let kAnimationKey = "rotation"
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
        return (self.layer.presentation()?.transform)!
    }
    
    func dispear(duration: Double = 0.4, finished: (()->Void)? = nil) {
        self.isHidden = false
        self.alpha = 1.0
        UIView.animate(
            withDuration: TimeInterval(duration),
            animations: {
                self.alpha = 0.0
            },
            completion: {
                if $0 {
                    self.isHidden = true
                    if let runCode = finished {
                        runCode()
                    }
                }
            }
        )
    }
    
    func appear(duration: Double = 0.2, finished: (()->Void)? = nil) {
        self.isHidden = false
        self.alpha = 0.0
        UIView.animate(
            withDuration: TimeInterval(duration),
            
            animations: {
                self.alpha = 1.0
            },
            completion: {
                if $0 {
                    if let runCode = finished {
                        runCode()
                    }
                }
            }
        )
    }
    
    func disappearWhileRotating(duration: Double = 1) {
        let kAnimationKey = "disappearWhileRotating"
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.toValue = Float(M_PI)
            
            let animate2 = CABasicAnimation(keyPath: "opacity")
            animate2.fromValue = 1.0
            animate2.toValue = 0.0
            
            let group = CAAnimationGroup()
            group.animations = [animate, animate2]
            group.duration = duration
            group.repeatCount = 1.0
            group.isRemovedOnCompletion = true
            
            self.layer.add(group, forKey: kAnimationKey)
        }
    }
    
    func changeColor(duration: Double = 1, color: UIColor, finished: (()->Void)? = nil) {
        self.isHidden = false
        self.alpha = 1.0
        UIView.animate(
            withDuration: TimeInterval(duration),
            animations: {
                self.layer.backgroundColor = color.cgColor
        },
            completion: {
                if $0 {
                    if let runCode = finished { runCode() }
                }
        })
    }
    
    func changeTintColor(duration: Double = 1, color: UIColor, finished: (()->Void)? = nil) {
        self.isHidden = false
        self.alpha = 1.0
        UIView.animate(
            withDuration: TimeInterval(duration),
            animations: {
                self.tintColor = color
        },
            completion: {
                if $0 {
                    if let runCode = finished { runCode() }
                }
        })
    }
    
}

extension UIImageView {
    
    func changeImage(duration: Double = 1, changeToImage: UIImage, finished: (()->Void)? = nil) {
        UIView.animate(withDuration: TimeInterval(duration),
                       delay: 0,
                       options: [.allowAnimatedContent, .transitionCrossDissolve],
                       animations: {
                        self.image = changeToImage
        },
                       completion: {
                        if $0 {
                            if let runCode = finished {
                                runCode()
                            }
                        }
        })
    }
    
}

extension UIColor {
    
    class var lightBlue: UIColor {
        get {
            return UIColor(red: 0.532, green: 0.714, blue: 0.996, alpha: 1.0)
        }
    }
    
    var lightGreen: UIColor {
        get {
            return UIColor(red: 0.2, green: 0.85, blue: 0.2, alpha: 1.0)
        }
    }
    
    var lightRed: UIColor {
        get {
            return UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
        }
    }
}
