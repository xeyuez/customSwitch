//
//  CustomSwitch.swift
//  customSwitch
//
//  Created by yumez on 2018/3/30.
//  Copyright © 2018年 yuez. All rights reserved.
//

import UIKit


struct SwitchStyle {
    let onViewBackgroundColor: UIColor = UIColor.green
    let offViewBackgroundColor: UIColor = UIColor.darkGray
    let middleViewBackgroundColor: UIColor = UIColor.white
    
    let onLabelTextColor: UIColor = UIColor.black
    let onLabelFont: UIFont = UIFont.systemFont(ofSize: 13)
    
    let offLabelTextColor: UIColor = UIColor.white
    let offLabelFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    var onLabelText: String = "打开"
    var offLabelText: String = "关闭"
    let middleMargins: CGFloat = 3
    var radius: SwitchRadius = .round
}

enum SwitchRadius {
    case square
    case round
}


class CustomSwitch: UIControl {
    var onBackView: UIView
    var onLabel: UILabel
    var offBackView: UIView
    var offLabel: UILabel
    var middleView: UIView
    
    var onChage: ((Bool) -> Void)?
    
    var On: Bool = false {
        didSet{
            updateUI()
        }
    }
    
    let style = SwitchStyle()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isON() -> Bool {
        return On
    }
    
    override init(frame: CGRect) {
        
        // on
        onBackView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        onBackView.backgroundColor = UIColor.cyan
        
        onLabel = UILabel(frame: CGRect(x: 0, y: 10, width: frame.width/2, height: frame.height - 20))
        onLabel.textAlignment = .center
        onLabel.font = style.onLabelFont
        onLabel.textColor = style.onLabelTextColor
        onLabel.text = style.onLabelText
        onBackView.addSubview(onLabel)
        
        // off
        offBackView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        offBackView.backgroundColor = style.offViewBackgroundColor
        
        offLabel = UILabel(frame: CGRect(x: frame.width/2, y: 10, width: frame.width/2, height: frame.height - 20 ))
        offLabel.textAlignment = .center
        offLabel.font = style.offLabelFont
        offLabel.textColor = style.offLabelTextColor
        offLabel.text = style.offLabelText
        offBackView.addSubview(offLabel)
        
        
        // middle
        middleView = UIView(frame: CGRect(x: 0, y: 0, width: frame.height - style.middleMargins, height: frame.height - style.middleMargins))
        middleView.backgroundColor = style.middleViewBackgroundColor
        middleView.isUserInteractionEnabled = true
        
        super.init(frame: frame)
        
        let tapViewsGes = UITapGestureRecognizer(target: self, action: #selector(didTapViews(_ :)))
        self.addGestureRecognizer(tapViewsGes)
        
        let tapMiddleGes = UITapGestureRecognizer(target: self, action: #selector(didTapMiddleView(_ :)))
        middleView.addGestureRecognizer(tapMiddleGes)
        
        let panMiddle = UIPanGestureRecognizer(target: self, action: #selector(panMiddleView(_ :)))
        self.middleView.addGestureRecognizer(panMiddle)
        
        self.addSubview(onBackView)
        self.addSubview(offBackView)
        self.addSubview(middleView)
        
        if style.radius == .round {
            middleView.layer.cornerRadius = (frame.height - style.middleMargins) / 2
            middleView.layer.shadowOffset = CGSize(width: 0, height: 1)
            
            self.layer.cornerRadius = frame.height / 2
            onBackView.layer.cornerRadius = frame.height / 2
            offBackView.layer.cornerRadius = frame.height / 2
        }
        
        updateUI()
    }
    
    
    func updateUI() {
        if On {
            offLabel.alpha = 0
            offBackView.alpha = 0
            
            onBackView.alpha = 1
            onLabel.alpha = 1
            self.middleView.center = CGPoint(x: self.frame.width-middleView.frame.width/2 - style.middleMargins/2 , y: self.frame.height/2)
            
            self.offBackView.transform = CGAffineTransform(scaleX: 0, y: 0)
        } else {
            offLabel.alpha = 1
            offBackView.alpha = 1
            
            onBackView.alpha = 0
            onLabel.alpha = 0
            self.middleView.center = CGPoint(x: middleView.frame.width/2 + style.middleMargins/2 , y: self.frame.height/2)
            
            self.offBackView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    
    @objc func didTapMiddleView(_ tap: UITapGestureRecognizer) {
        if tap.state == UIGestureRecognizerState.ended {
            
            if self.isON() {
                moveToLeft()
            } else {
                moveToRight()
            }
            
        }
    }
    
    @objc func didTapViews(_ tap: UITapGestureRecognizer) {
        
        if self.isON() {
            moveToLeft()
        } else {
            moveToRight()
        }
    }
    
    @objc func panMiddleView(_ pans: UIPanGestureRecognizer) {
        
        
        guard let tapView = pans.view else { return }
        
        let transPoint: CGPoint = pans.translation(in: self.middleView)
        
        let centerPoint = CGPoint(x: tapView.center.x + transPoint.x, y: tapView.center.y)
        
        if (centerPoint.x < (tapView.frame.size.width + style.middleMargins)/2 || centerPoint.x > self.onBackView.frame.size.width - (tapView.frame.size.width + style.middleMargins)/2) {
            if pans.state == UIGestureRecognizerState.began || pans.state == UIGestureRecognizerState.changed {
                let velocityPoint = pans.velocity(in: self.middleView)
                if velocityPoint.x > 0 {
                    moveToRight()
                }else {
                    moveToLeft()
                }
            }
            return
        }
        
        tapView.center = CGPoint(x: tapView.center.x + transPoint.x, y: tapView.center.y)
        
        pans.setTranslation(CGPoint(x: 0 ,y: 0), in: self.middleView)
        
        let velocityPoint = pans.velocity(in: self.middleView)
        if pans.state == UIGestureRecognizerState.ended {
            if velocityPoint.x > 0 {
                
                if tapView.center.x < self.onBackView.frame.size.width - (self.middleView.frame.width + style.middleMargins)/2 {
                    moveToRight()
                }
                
            } else {
                moveToLeft()
            }
        }
        
    }
    
    func moveToLeft() {
        self.animationToDestination( CGPoint(x: middleView.frame.width/2 + style.middleMargins/2 , y: self.frame.height/2), duration: 0.3, on: false)
    }
    
    func moveToRight() {
        self.animationToDestination(  CGPoint(x: (self.frame.width-middleView.frame.width/2) - style.middleMargins/2, y: self.frame.height/2), duration: 0.3, on: true)
        
    }
    
    
    func animationToDestination(_ center: CGPoint, duration: CGFloat, on: Bool) {
        
        UIView.animate(withDuration: TimeInterval(duration),
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        
                        self.middleView.center = center
                        if on {
                            self.onBackView.alpha = 1
                        } else {
                            self.onBackView.alpha = 0
                        }
        }) { finished in
            if finished {
                self.updateSwich(on)
            }
        }
        
        
        UIView.animate(withDuration: TimeInterval(duration),
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        if on {
                            self.offBackView.alpha = 0
                        } else {
                            self.offBackView.alpha = 1
                        }
        }) { _ in
        }
    }
    
    func updateSwich(_ on: Bool) {
        if on != On {
            On = on
            onChage?(on)
        }
    }
    
    
}
