//
//  AccountSecurityViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/18.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class AccountSecurityViewController: UITableViewController {

    
    @IBOutlet weak var userIdLb: UILabel!
    
    
    @IBOutlet weak var editPasswordLb: UILabel!
    
    @IBOutlet weak var phoneLb: UILabel!
    
    
    @IBOutlet weak var wx_bindStatusLb: UILabel!
    
    @IBOutlet weak var qq_bindStatusLb: UILabel!
    
    
    @IBOutlet weak var realNameStatusLb: UILabel!
    @IBOutlet weak var fb_bindStatusLb: UILabel!
    
    var bindModel:BindInfoModel?
    
    func _requestBindData(){
        SCNetwork.shareInstance().v1_post(withUrl: User_Bind_URL, params: ["userId":SCCacheTool.shareInstance().getCurrentUser()], showLoading: true) { [weak self] (baseModel, error) in
            if let model = BindInfoModel.deserialize(from: baseModel?.data as? Dictionary){
                self?._bind(model)
                self?.bindModel = model
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "账号与安全"
        _requestBindData()
    }
    
    func _bind(_ model:BindInfoModel){
      userIdLb.text = model.userId
      editPasswordLb.text = model.pwTitle
      phoneLb.text = model.mobile
      wx_bindStatusLb.text = model.wxBindTitle
      qq_bindStatusLb.text = model.qqBindTitle
      fb_bindStatusLb.text = model.fbBindTitle
      realNameStatusLb.text = model.idCardTitle
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            switch indexPath.row {
            case 1:
                if self.bindModel?.password == false{
                    self.performSegue(withIdentifier: "setPassword", sender: nil)
                }else{
                     self.performSegue(withIdentifier: "resetPassword", sender: nil)
                }

                break
            case 2:
                hrShowAlert(withTitle: "更换已绑定的手机号？", message: bindModel?.mobile, buttonsTitles: ["取消","更换"]) { (_, idx) in
                    if idx == 1{
                        self.performSegue(withIdentifier: "bindPhone", sender: nil)
                    }
                }
                
                break
            default: break
                
            }
        }
        
        if indexPath.section == 1{
            if indexPath.row == 3{// 实名认证
                let realNameVC = RealNameVeifiedViewController()
                navigationController?.pushViewController(realNameVC, animated: true)
                return
            }
            
            if self.bindModel?._isBind(indexPath.row) == true{
                self.hrShowAlert(withTitle: nil, message: "是否解除绑定该账号", buttonsTitles: ["解绑","取消"]) { (_, index) in
                    if index == 0{
                        self._changeBindData(indexPath)
                    }
                }
            }else{
                self._changeBindData(indexPath)
            }
            
        }
        
    }
    
    func _changeBindData(_ indexPath:IndexPath){
        self.bindModel?._getBindParameter(indexPath.row, { (dic) in
            SCNetwork.shareInstance().v1_post(withUrl: User_Bind_Account_URL, params: dic, showLoading: true, call: { (baseModel, error) in
                if let data = baseModel?.data as? Int{
                    if data == 5{
                        HHTool.showSucess("解绑成功")
                    }
                    if data == 1{
                        HHTool.showSucess("绑定成功")
                    }
                   _ =  delay(1.0, task: {
                        self._requestBindData()
                    })
                    
                }
            })
        })
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? ResetPasswordViewController {
            if segue.identifier == "resetPassword" {
                controller.pageType = .resetPassword
            }else if segue.identifier == "bindPhone"{
                controller.pageType = .bindPhone
            }
            
        }
    }
    
}
