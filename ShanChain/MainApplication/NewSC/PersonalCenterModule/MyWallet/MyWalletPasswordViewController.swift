//
//  MyWalletPasswordViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/30.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit


class MyWalletPasswordViewController: SCBaseVC {


    
    @IBOutlet weak var selectImageBtn: UIButton!
    
    @IBOutlet weak var generateBtn: UIButton!
    
    var disposeBag = DisposeBag()
    var imageData:Data?
    var imageURL:String?
    
    func _clickTip(){
        _ = self.sc_hrShowAlert(withTitle: "温馨提示", message: "该钱包安全码仅展示一次\n不可修改、不可找回！\n请检查您的相册里是否已保存。", buttonsTitles: ["我已保存","马上保存"], andHandler: { (_, index) in
            if index == 1{
                
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "钱包密码"
        generateBtn.isUserInteractionEnabled = false
       // addRightBarButtonItem(withTarget: self, sel: #selector(_clickTip), title: "提示", tintColor: SC_ThemeMainColor)
        selectImageBtn.rx.tap.subscribe(onNext: { [weak self] in
        DUX_UploadUserIcon.shareUploadImage().showActionSheet(inFatherViewController: self, imageTag: 214, delegate: self)
        }).disposed(by: disposeBag)
        
        generateBtn.rx.tap.subscribe(onNext: { [weak self] in
          _ =  self?.sc_hrShowAlert(withTitle: nil, message: "即将生成安全码，生成后将不可更改，是否确认生成?", buttonsTitles: ["取消","确认"], andHandler: { (_, index) in
                if index == 1{
                    SCNetwork.shareInstance().hh_uploadFile(withArr: [self?.imageData ?? ""], url: GetWalletPassword_URL, parameters: [:], showLoading: true, call: { (baseModel, error) in
                        if let data = baseModel?.data as? Data{
                            let saveVC = MyWalletGenerateSuccessViewController(codePasswordData: data)
                            self?.navigationController?.pushViewController(saveVC, animated: true)
                        }
                    })
                }
            })
            
            
        }).disposed(by: disposeBag)
        
    }

}


extension MyWalletPasswordViewController:DUX_UploadUserIconDelegate{
    
    func uploadImageToServer(with image: UIImage!, tag: Int) {
        self.imageData = image.mc_reset(to: CGSize(width: 100, height: 100)).pngData()
        generateBtn.backgroundColor = SC_ThemeMainColor
        generateBtn.isUserInteractionEnabled = true
        selectImageBtn.setImage(image, for: .normal)
    }
    func uploadImageToServer(with image: UIImage!, fileUrl: String!) {
        self.imageURL = fileUrl;
    }
}


