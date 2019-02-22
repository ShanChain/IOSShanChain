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
    var smsVerifyModel:SmsVerifycodeModel?
    let mobile = SC_phoneNumber ?? SCCacheTool.shareInstance().mobile
    
    func _getParameter() -> Dictionary<String,Any> {
        if isChangePassword == true {
            return (smsVerifyModel?._getSetPasswordParameter(settingTextFid.text!))!
        }
        
        let pwdMD5 = SCMD5Tool.md5(forUpper32Bate: settingTextFid.text!)
        let time:Int64 = Int64(Date().timeIntervalSince1970)
        let typeAppend = "USER_TYPE_MOBILE\(time)"
        let encryptAccount = SCAES.encryptShanChain(withPaddingString: typeAppend, withContent: mobile)
        let encryptPassword = SCAES.encryptShanChain(withPaddingString: "\(typeAppend)\(mobile)", withContent: pwdMD5)
        return ["userType":"USER_TYPE_MOBILE","Timestamp":"\(time)","encryptAccount":encryptAccount ?? "","encryptPassword":encryptPassword ?? ""]
    }
    
    
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
        
            typealias JSON = Int
            let json:Observable<JSON> = Observable.create { (observer) -> Disposable in
                SCNetwork.shareInstance().v1_post(withUrl: Reset_Password_URL, params:self?._getParameter(), showLoading: true, call: { (baseModel, error) in
                    guard error == nil else{
                        observer.onError(error!)
                        return
                    }
                    
                    guard let data = baseModel?.data as? Int else{
                         HHTool.showError("重置密码失败")
                         return
                    }
                    
                    observer.onNext(data)
                    observer.onCompleted()
                })
                return Disposables.create()
            }
            
            json.subscribe(onNext: { json in
            
                if json == 1{
                    var title:String = "密码重置成功! 请重新登录"
                    if self?.isChangePassword == false{
//                        HHTool.showTip("密码设置成功!", duration: 1.5)
                        title = "密码设置成功! 请重新登录"
                    }else{
                       // HHTool.showTip("密码重置成功!", duration: 1.5)
                        
                    }
                    self?.sc_hrShowAlert(withTitle: nil, message: title, buttonsTitles: ["确定"], andHandler: { (_, _) in
                        SCAppManager.shareInstance().logout()
                    })
//                    _ = delay(1.0, task: {
//
//                    })
                }
                
                }, onError: { error in
                    print("取得 json 失败 Error: \(error.localizedDescription)")
                }, onCompleted: {
                    print("取得 json 任务成功完成")
                })
                .disposed(by: (self?.disposeBag)!)
            
        }).disposed(by: disposeBag)
    }

 
    @IBAction func completeAction(_ sender: UIButton) {
    }
    
}
