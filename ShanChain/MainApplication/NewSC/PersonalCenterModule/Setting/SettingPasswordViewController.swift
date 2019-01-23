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
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "设置密码"
        let passwordValid = settingTextFid.rx.text.orEmpty
            .map { $0.count > 0 }.shareReplay(1)
        
        settingTextFid.rx.text.orEmpty.subscribe(onNext: { (text) in
            if text.length == 0{
                self.completeBtn.backgroundColor = SC_CantClickColor
            }else{
                self.completeBtn.backgroundColor = SC_ThemeMainColor
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
