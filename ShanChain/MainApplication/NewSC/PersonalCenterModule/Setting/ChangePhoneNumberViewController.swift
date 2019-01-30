//
//  ChangePhoneNumberViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/28.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class ChangePhoneNumberViewController: SCBaseVC {
    
    
    var disposeBag = DisposeBag()
    
    
    @IBOutlet weak var completeBtn: UIButton!
    
    @IBOutlet weak var phoneFid: UITextField!
    
    var smsVerifyModel:SmsVerifycodeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let phoneValid = phoneFid.rx.text.orEmpty
            .map { $0.isValidPhoneNumber() == true}.shareReplay(1)
        
        phoneFid.rx.text.orEmpty.subscribe(onNext: { (text) in
            if text.isValidPhoneNumber() == false{
                self.completeBtn.backgroundColor = SC_CantClickColor
            }else{
                self.completeBtn.backgroundColor = SC_ThemeMainColor
            }
            
            if text.length == 11 && text.isValidPhoneNumber() == false{
                HHTool.showError("手机号格式有误!")
            }
            
        }).disposed(by: disposeBag)
        phoneValid.bind(to: completeBtn.rx.isEnabled).disposed(by: disposeBag)
        completeBtn.rx.tap.subscribe(onNext: { [weak self] in
            SCNetwork.shareInstance().v1_post(withUrl: Change_phone_URL, params: self?.smsVerifyModel?._changePhoneNumberParameter((self?.phoneFid.text!)!), showLoading: true, call: { (baseModel, error) in
                guard error == nil else{
                    return
                }
                
                if let _ = baseModel?.data as? Dictionary<String,Any>{
                    UserDefaults.standard.set(self?.phoneFid.text, forKey: "K_USERNAME")
                    UserDefaults.standard.synchronize()
                    HHTool.showTip("绑定手机号修改成功！", duration: 1.0)
                    _ = delay(1.0, task: {
                        self?.navigationController?.popToRootViewController(animated: true)
                    })
                }
            })
            
        }).disposed(by: disposeBag)
    }
    

}
