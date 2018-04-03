//
//  ViewController.swift
//  customSwitch
//
//  Created by yumez on 2018/3/30.
//  Copyright © 2018年 yuez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var switchBtn: CustomSwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchBtn = CustomSwitch(frame: CGRect(x: 100, y: 100, width: 300, height: 50))
        self.view.addSubview(switchBtn!)
        
        switchBtn?.onChage = { isOn in
            self.didTap(isOn: isOn)
        }
        
        
        
        let vs = customProgress(frame: CGRect(x: 50, y: 200, width: 200, height: 200))
        vs.backgroundColor = UIColor.lightGray
        vs.startAnimation()
        self.view.addSubview(vs)
    }

    func didTap(isOn: Bool) {
        print("Did Tap  isOn: \(isOn)")
    }
}

