//
//  MyWalletWelcomeViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/31.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class MyWalletWelcomeViewController: SCBaseVC {

    
    var disposeBag = DisposeBag()
    @IBOutlet weak var joinWalletBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
//        let  walletPage:[MyWalletViewController] =  self.navigationController?.viewControllers.filter{
//            return $0 is MyWalletViewController
//            } as! [MyWalletViewController]
        joinWalletBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.isNavigationBarHidden = false
            let walletVC = MyWalletViewController()
            self?.navigationController?.pushViewController(walletVC, animated: true)
//            walletPage.last?._deallocCache()
//            self?.navigationController?.popToViewController((walletPage.last)!, animated: true)
        }).disposed(by: disposeBag)
        
        
        self.hh_rewriteBackActionFunc(#selector(_back))
        
    }
    
    func _back(){
        self.dismissPrestingViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }

}
