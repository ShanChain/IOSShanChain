//
//  SettingPasswordViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/23.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class SettingPasswordViewController: SCBaseVC {

    
    @IBOutlet weak var completeBtn: UIButton!
    
    @IBOutlet weak var settingTextFid: UITextField!
    
    @IBOutlet weak var settingTitleLb: UILabel!
    
    @IBOutlet weak var tipLb: UILabel!
    
    var isChangePassword:Bool = false // 是否是更换密码
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置密码"
        if isChangePassword == true{
            settingTitleLb.text = "设置新的登录密码"
        }
        let passwordValid = settingTextFid.rx.text.orEmpty
            .map { $0.isValidatePassword() == true}.shareReplay(1)
        
        settingTextFid.rx.text.orEmpty.subscribe(onNext: { (text) in
            if text.isValidatePassword() == false{
                self.completeBtn.backgroundColor = SC_CantClickColor
            }else{
                self.completeBtn.backgroundColor = SC_ThemeMainColor
            }
            
            if text.length >= 8 && text.length <= 20 && text.isValidatePassword() == false{
                self.tipLb.text = "密码格式错误！"
                self.tipLb.textColor = .red
            }else{
                self.tipLb.text = "密码8~20位，至少包含字母/数字/符号2种组合"
                self.tipLb.textColor = SC_CantClickColor
            }
            
        }).disposed(by: disposeBag)
        passwordValid.bind(to: completeBtn.rx.isEnabled).disposed(by: disposeBag)
        
        completeBtn.rx.tap.subscribe(onNext: { [weak self] in
            print("点击完成")
        }).disposed(by: disposeBag)
    }

 
    @IBAction func completeAction(_ sender: UIButton) {
    }
    
}
