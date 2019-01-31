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
    
    @IBOutlet weak var privacyBtn: UIButton!
    var disposeBag = DisposeBag()
    
    
    func pushH5(_ url:String, _ title:String){
        let  vc = MyWalletViewController()
        vc.urlStr =  url
        vc.isShowNav = true
        vc.title = title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "关于马甲"
        pactBtn.rx.tap.subscribe(onNext: { [weak self] in
            // 用户协议
            self?.pushH5("http://h5.qianqianshijie.com/agreement","用户协议")
        }).disposed(by: disposeBag)
        
        officialSiteBtn.rx.tap.subscribe(onNext: { [weak self] in
           // 官网
            self?.pushH5("https://marjar.app","马甲官网")
        }).disposed(by: disposeBag)
        
        privacyBtn.rx.tap.subscribe(onNext: { [weak self] in
            // 隐私政策
            self?.pushH5("http://h5.qianqianshijie.com/privacy","隐私政策")
        }).disposed(by: disposeBag)
    }


}
