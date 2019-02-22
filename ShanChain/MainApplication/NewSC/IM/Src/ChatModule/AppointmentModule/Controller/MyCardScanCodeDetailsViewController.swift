//
//  MyCardScanCodeDetailsViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/17.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class MyCardScanCodeDetailsViewController: SCBaseVC {
   
    
    @IBOutlet weak var nameLb: UILabel!
    
    
    @IBOutlet weak var icon: UIImageView!
    
    
    @IBOutlet weak var codeImageView: UIImageView!
    
    
    @IBOutlet weak var dealTimeLb: UILabel!
    
    var detailsModel:CouponsDetailsModel?
    var createQR_jsonStr:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "马甲劵详情"
        nameLb.text = detailsModel?.tokenName
        codeImageView.image = ScanCodeService.createQR(with: createQR_jsonStr, size: codeImageView.size)
         self.icon._sd_setImage(withURLString: self.detailsModel?.photoUrl, placeholderImage:UIImage.loadImage(DefaultAvatar))
        self.dealTimeLb.text = detailsModel?.deadlineStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
