//
//  MyWalletGenerateSuccessViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/30.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class MyWalletGenerateSuccessViewController: SCBaseVC {

    
    @IBOutlet weak var codeIcon: UIImageView!
    
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    var disposeBag = DisposeBag()
    var codeData:Data!
    var photeManager: SavePhotoToAssignpath = {
        let  manager = SavePhotoToAssignpath(folderName: SC_SavePhotoFileName)
        return manager!
    }()
    
    func _clickTip(){
        _ = self.sc_hrShowAlert(withTitle: "温馨提示", message: "该钱包安全码仅展示一次\n不可修改、不可找回！\n请检查您的相册里是否已保存。", buttonsTitles: ["我已保存","马上保存"], andHandler: { (_, index) in
            if index == 1{
                self.savePhoto()
            }
        })
    }
    
    required init(codePasswordData:Data) {
        self.codeData = codePasswordData
        super.init(nibName: "MyWalletGenerateSuccessViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func savePhoto(){
        DispatchQueue.main.async(execute: {
            HHTool.showSucess("保存成功")
            self.nextBtn.isEnabled = true
            self.nextBtn.backgroundColor = SC_ThemeMainColor
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "钱包密码"
        nextBtn.isEnabled = false
        addRightBarButtonItem(withTarget: self, sel: #selector(_clickTip), title: "提示", tintColor: SC_ThemeMainColor)
        codeIcon.image = UIImage(data: codeData)
        saveBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.photeManager.saveData(withPhtotoKit: self?.codeData, completion: { (status, _) in
                if status == true{
                  self?.savePhoto()
                }
            })
            
        }).disposed(by: disposeBag)
        
        nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            let vc = MyWalletWelcomeViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }


}
