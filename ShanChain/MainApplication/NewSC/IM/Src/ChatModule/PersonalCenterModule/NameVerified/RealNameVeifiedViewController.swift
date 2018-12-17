//
//  RealNameVeifiedViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/7.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class RealNameVeifiedViewController: SCBaseVC {
 
    
    @IBOutlet weak var nameFid: UITextField!
    
    @IBOutlet weak var cardIDFid: UITextField!
    
    
    @IBOutlet weak var certificationBtn: UIButton!
    
    
    @IBAction func certificationAction(_ sender: Any) {
        if self._isValid() {
            SCNetwork.shareInstance().getWithUrl(RealNameVerified_URL, parameters: ["cardno":cardIDFid.text!,"name":nameFid.text,"userId":SCCacheTool.shareInstance().getCurrentUser()], success: { (result) in
                HHTool.showSucess("认证成功")
                self.navigationController?.popViewController(animated: true)
            }) { (error) in
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "实名认证"
        
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
