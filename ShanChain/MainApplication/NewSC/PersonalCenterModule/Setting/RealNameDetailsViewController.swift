//
//  RealNameDetailsViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/29.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class RealNameDetailsViewController: SCBaseVC {

    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var cardTypeLb: UILabel!
    
    @IBOutlet weak var cardNumberLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "实名认证"
        _getData()
    }
    
    func updateUI(_ model:RealNameVerifiedDetailsModel){
        nameLb.text = model.realName
        cardTypeLb.text = model.cardType
        cardNumberLb.text = model.idCard
    }
    
    func _getData(){
        SCNetwork.shareInstance().hh_Get(withUrl: RealVerified_detail_URL, parameters: [:], showLoading: true) { (baseModel, error) in
            guard error == nil else{
                return
            }
            
            guard ((baseModel?.data as? Dictionary<String,Any>) != nil) else{
                return
            }
            
            let model = RealNameVerifiedDetailsModel.deserialize(from: baseModel?.data as? Dictionary<String,Any>)
            self.updateUI(model!)
        }
    }
}
