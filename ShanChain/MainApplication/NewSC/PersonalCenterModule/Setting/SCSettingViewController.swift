//
//  SCSettingViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/18.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class SCSettingViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
       
    }
    
    
    @IBAction func modifyPushStateAction(_ sender: UISwitch) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 3{
            SCAppManager.shareInstance().selectLogout()
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            // 意见反馈
            let vc = OpinionFeedbackViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.section == 2 && indexPath.row == 2 {
            // 检查更新
            SCNetwork.shareInstance().v1_post(withUrl: checkUpdate_URL, params: ["type":"ios"], showLoading: true) { (baseModel, error) in
                if let data = baseModel?.data as? Dictionary<String,Any>{
                     let model = VersionUpdateModel.deserialize(from: data)
                     let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
                    
                    if ((model?.version) != nil) && (NSString.compareVersion(version as! String, withServerVersion: model?.version) == true){
                        if model?.forceUpdate == true{
                            // 强制更新
                            self.hrShowAlert(withTitle: nil, message: "新版本有较大改进，请更新", buttonsTitles: ["确定"], andHandler: { (_, _) in
                                UIApplication.shared.openURL(URL(string: (model?.url)!)!)
                            })
                            
                        }else{
                            // 选择更新
                            self.hrShowAlert(withTitle: nil, message: "新版本有较大改进，请更新", buttonsTitles: ["取消","确定"], andHandler: { (_, index) in
                                if index == 1{
                                    UIApplication.shared.openURL(URL(string: (model?.url)!)!)
                                }
                            })
                        }
                    }else{
                        // 已经是最新版本
                        HHTool.showTip("当前已是最新版本", duration: 1.0)
                    }
                }
            }
        }
        
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 3 {
//            return 150
//        }
//        return 15
//    }

}
