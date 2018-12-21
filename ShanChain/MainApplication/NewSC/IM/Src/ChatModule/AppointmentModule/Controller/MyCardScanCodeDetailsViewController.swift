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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "马甲劵详情"
        codeImageView.image = ScanCodeService.createQR(with: "123232434", size: codeImageView.size)
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
