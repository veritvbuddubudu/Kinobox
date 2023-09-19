//
//  AnimatedGradient.swift
//  Kinobox
//
//  Created by Елена Горбунова on 02.08.2023.
//

import UIKit

extension UIButton {
    
    func animatedGradient(colors: [CGColor]) {
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        gradient.cornerRadius = 10
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        
        self.layer.addSublayer(gradient)
        
        let startPointAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
        startPointAnimation.fromValue = CGPoint(x: 4, y: 0)
        startPointAnimation.toValue = CGPoint(x: 0, y: 7)
        
        let endPointAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
        endPointAnimation.fromValue = CGPoint(x: 0, y: 7)
        endPointAnimation.toValue = CGPoint(x: 4, y: 0)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [startPointAnimation, endPointAnimation]
        
        animationGroup.duration = 6
        animationGroup.repeatCount = .infinity
        gradient.add(animationGroup, forKey: nil)
    }
}
