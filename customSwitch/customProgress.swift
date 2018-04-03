//
//  customProgress.swift
//  customSwitch
//
//  Created by yumez on 2018/4/3.
//  Copyright © 2018年 yuez. All rights reserved.
//

import UIKit

class customProgress: UIView, CAAnimationDelegate {
    var loadLayer: CAShapeLayer?
    var isEnable: Bool = false
    var duration: TimeInterval = 2

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    func setUp() {
        loadLayer = CAShapeLayer()
        loadLayer?.lineWidth = 3
        loadLayer?.fillColor = UIColor.clear.cgColor
        loadLayer?.strokeColor = UIColor.red.cgColor
        
        self.layer.addSublayer(loadLayer!)
        loadLayer?.lineCap = kCALineCapRound
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadAnimation() {
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        strokeEndAnimation.duration = duration * 0.5
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = duration
        
        groupAnimation.delegate = self
        groupAnimation.duration = duration
        groupAnimation.animations = [strokeStartAnimation, strokeEndAnimation]//, strokeEndAnimation]
    
        loadLayer?.add(groupAnimation, forKey: "hehe")
    }
    
    func returnLoadViewPath() -> UIBezierPath {
        let width = self.bounds.size.width
        let center = CGPoint(x: width/2, y: self.bounds.size.height/2)
        let path = UIBezierPath(arcCenter: center, radius: width/3, startAngle: -CGFloat(Double.pi), endAngle: CGFloat(Double.pi), clockwise: true)
        return path
    }
    
    
    // delegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("====   animationDid Stop")
        self.loadLayer?.path = nil
        self.loadLayer?.removeAllAnimations()
        if (!self.isEnable) {
            return
        }
        self.loadLayer?.path = returnLoadViewPath().cgPath
        self.loadAnimation()
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        print("++++   animationDid Start")
    }
   
    
    
    // starte stop
    func startAnimation() {
        if let keys = self.loadLayer?.animationKeys(), keys.count > 0 {
            return
        }
        
        self.isEnable = true
        self.loadAnimation()
    }
    
    func stopAnimation() {
        self.loadLayer?.removeAllAnimations()
        self.isEnable = false
    }
    
  
}
