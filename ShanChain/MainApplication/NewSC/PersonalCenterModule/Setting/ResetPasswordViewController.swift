//
//  ResetPasswordViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/23.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit


enum BindPageType:Int {
    case bindPhone = 1
    case resetPassword
}


class ResetPasswordViewController: SCBaseVC {

    
    @IBOutlet weak var codeFid: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var bindPhoneLb: UILabel!
    @IBOutlet weak var codeBtn: UIButton!
    
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var errorTipLb: UILabel!
    var disposeBag = DisposeBag()
    var pageType:BindPageType = .bindPhone
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindPhoneLb.text = "输入当前绑定手机\n1888888888发送短信"
        
        
        if pageType ==  .bindPhone{
            title = "更换绑定手机"
            titleLb.text = "更换绑定手机"
            
        }else if pageType ==  .resetPassword{
             title = "重置密码"
             titleLb.text = "更换绑定手机"
        }
        
        let codeValid = codeFid.rx.text.orEmpty
            .map { $0.count > 0 }.shareReplay(1)
        
        codeFid.rx.text.orEmpty.subscribe(onNext: { (text) in
            if text.length == 0{
                self.nextBtn.backgroundColor = SC_CantClickColor
            }else{
                self.nextBtn.backgroundColor = SC_ThemeMainColor
            }
        }).disposed(by: disposeBag)
        codeValid.bind(to: nextBtn.rx.isEnabled).disposed(by: disposeBag)
        
        nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            print("点击下一步")
        }).disposed(by: disposeBag)
        
        
        codeBtn.rx.tap.subscribe(onNext: { [weak self] in
            // 发送验证码
        SCNetwork.shareInstance().v1_post(withUrl: GetVerifycode_URL, params: ["mobile":"18888888"], showLoading: true, call: { (baseModel, error) in
                    if error != nil{
                        return
                    }
             self?.codeBtn.start(withTime: 59, title: NSLocalizedString("sc_login_Resend", comment: "字符串"), countDownTitle: "s", mainColor: SC_EmphasisColor, count: SC_EmphasisColor)
            
          })
            
        }).disposed(by: disposeBag)
        
    }
    
}


