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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "账号与安全"
        SCNetwork.shareInstance().v1_post(withUrl: User_Bind_URL, params: ["userId":SCCacheTool.shareInstance().getCurrentUser()], showLoading: true) { [weak self] (baseModel, error) in
            if let model = BindInfoModel.deserialize(from: baseModel?.data as? Dictionary){
                self?._bind(model)
                self?.bindModel = model
            }
        }
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
            
        }
        
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
