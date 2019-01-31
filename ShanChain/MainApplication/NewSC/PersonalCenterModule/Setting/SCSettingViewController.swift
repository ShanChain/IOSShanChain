//
//  SCSettingViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/18.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class SCSettingViewController: UITableViewController {

    @IBOutlet weak var pushSwich: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        showNavigationBarWhiteColor()
        pushSwich.isOn = SCCacheTool.shareInstance().characterModel.characterInfo.allowNotify
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
           PersonalCenterService._checkingUpdate(true)
        }
    }
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 3 {
//            return 150
//        }
//        return 15
//    }

}
