//
//  RealNameVeifiedViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/7.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit
import ASExtendedCircularMenu

class RealNameVeifiedViewController: SCBaseVC,ASCircularButtonDelegate {
    func willShowForMenuButton() {
        
    }
    
    func didDisappearForMenuButton() {
        
    }
    

    
    @IBOutlet weak var nameFid: UITextField!
    
    @IBOutlet weak var cardIDFid: UITextField!
    
    
    @IBOutlet weak var certificationBtn: UIButton!
    
    
    @IBOutlet weak var colourPickerButton: ASCircularMenuButton!
    
    
    @IBAction func certificationAction(_ sender: Any) {
        if self._isValid() {
            
        }
    }
    
    let colourArray: [UIColor] = [.red , .blue , .green , .yellow , .purple , .gray ,.black , .brown]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "实名认证"
        certificationBtn.cornerRadius = certificationBtn.height/2.0
        configureDraggebleCircularMenuButton(button: colourPickerButton, numberOfMenuItems: 8, menuRedius: 70, postion: .center)
        colourPickerButton.menuButtonSize = .medium
        colourPickerButton.sholudMenuButtonAnimate = false
    }

    
    func buttonForIndexAt(_ menuButton: ASCircularMenuButton, indexForButton: Int) -> UIButton {
        let button: UIButton = UIButton()
        if menuButton == colourPickerButton{
            button.backgroundColor = colourArray[indexForButton]
        }
        return button
    }
    
    func didClickOnCircularMenuButton(_ menuButton: ASCircularMenuButton, indexForButton: Int, button: UIButton) {
       
        
    }
    
    
    func _isValid() -> Bool {
      
        if (nameFid.text?.isEmpty)!{
            HHTool.showError("真实姓名不能为空")
            return false
        }
        
        if (cardIDFid.text?.isEmpty)!{
            HHTool.showError("身份证号不能为空")
            return false
        }
        
        if !((cardIDFid.text?.isValidIdentifiedCard())!) {
             HHTool.showError("请输入有效的身份证件")
            return false
        }
        
        return true
        
    }
}
