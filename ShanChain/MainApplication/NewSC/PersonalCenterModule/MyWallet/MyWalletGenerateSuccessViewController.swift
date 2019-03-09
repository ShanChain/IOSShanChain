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
                self._photeManagerSaveData()
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
            SCNetwork.shareInstance().hh_Get(withUrl: "/wallet/api/wallet/2.0/savePwd", parameters: ["token":""], showLoading: true, call: { (baseModel, error) in
                if error == nil{
                    HHTool.showSucess("保存成功")
                    self.nextBtn.isEnabled = true
                    self.nextBtn.backgroundColor = SC_ThemeMainColor
                }
               
            })
          
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.backButton.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backButton.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "钱包密码"
        nextBtn.isEnabled = false
        addRightBarButtonItem(withTarget: self, sel: #selector(_clickTip), title: "提示", tintColor: SC_ThemeMainColor)
        codeIcon.image = UIImage(data: codeData)
        saveBtn.rx.tap.subscribe(onNext: { [weak self] in
            if HHTool.checkDetectionPhotoPermission({}) == false{
                self?.sc_hrShowAlert(withTitle: "温馨提示", message: "您已关闭读取照片权限，请前往系统【设置】-【隐私】-【照片】中开启 允许读取和写入", buttonsTitles: ["确定"], andHandler: nil)
                return
            }
            
           self?._photeManagerSaveData()
            
        }).disposed(by: disposeBag)
        
        nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            let vc = MyWalletWelcomeViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    func _photeManagerSaveData(){
        self.photeManager.saveData(withPhtotoKit: self.codeData, completion: { (status, _) in
            if status == true{
                self.savePhoto()
            }else{
                self.photeManager.createFolder(SC_SavePhotoFileName, success: {
                    self._photeManagerSaveData()
                })
            }
        })
    }

}
