//
//  AboutMarJarViewContriller.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/25.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class AboutMarJarViewContriller: SCBaseVC {

    
    
    @IBOutlet weak var pactBtn: UIButton!
    @IBOutlet weak var officialSiteBtn: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "关于马甲"
        pactBtn.rx.tap.subscribe(onNext: { [weak self] in
            
        }).disposed(by: disposeBag)
        
        officialSiteBtn.rx.tap.subscribe(onNext: { [weak self] in
            
        }).disposed(by: disposeBag)
        
    }


}
