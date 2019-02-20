//
//  UploadPhotePasswordView.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/2/18.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

typealias UploadSuccessClosure = (_ isSuccess:Bool ,_ authCode:String) ->Void //定义闭包类型

class UploadPhotePasswordView: UIView {

    var contentView:UIView!
    var closure:UploadSuccessClosure?
    var imageData:Data?
    var imageURL:String?
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var selectImageBtn: UIButton!
    //    convenience init(listModel:TaskListModel,frame:CGRect) {
//        self.init(frame: frame)
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        alphaComponentMake()
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.snp.makeConstraints { (mark) in
            mark.edges.equalTo(self)
        }
        confirmBtn.isUserInteractionEnabled = false
        // addRightBarButtonItem(withTarget: self, sel: #selector(_clickTip), title: "提示", tintColor: SC_ThemeMainColor)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(removeFromSuperview))
        self.addGestureRecognizer(tap)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction func confirmAction(_ sender: Any) {
        let registrationID:String = JPUSHService.registrationID() ?? ""
        SCNetwork.shareInstance().hh_uploadFile(withArr: [self.imageURL ?? ""], url: CreateAuthCode_URL, parameters: ["deviceToken":registrationID], showLoading: true, call: { (baseModel, error) in
            if let authCode  = baseModel?.data , ((baseModel?.data as? String) != nil){
                self.closure!(true,authCode as! String)
                if SCCacheTool.shareInstance().characterModel.characterInfo.isBindPwd != true{
                    HHTool.getCurrentVC().sc_hrShowAlert(withTitle: "验证成功！", message: "您也可以选择开启免密功能，在下次使用马甲券时便无需再次上传安全码，让使用更加方便快捷，是否开通免密功能？", buttonsTitles: ["暂不需要","立即开通"], andHandler: { (_, index) in
                        if index == 1{
                            // 开通免密
                            EditInfoService.sc_editPersonalInfo(["bind":true], call: { (isSuccess) in
                                if isSuccess == true{
                                    SCCacheTool.shareInstance().setCacheValue(authCode as! String, withUserID:  SCCacheTool.shareInstance().getCurrentUser(), andKey: SC_AUTHCODE)
                                }
                            })
                        }
                    })
                }else{
                    SCCacheTool.shareInstance().setCacheValue(authCode as! String, withUserID:  SCCacheTool.shareInstance().getCurrentUser(), andKey: SC_AUTHCODE)
                }
                
            }
        })
    }

    
    
    @IBAction func uploadAction(_ sender: UIButton) {
        DUX_UploadUserIcon.shareUploadImage().showActionSheet(inFatherViewController: HHTool.getCurrentVC(), imageTag: 0, delegate: self as DUX_UploadUserIconDelegate)
    }
}


extension UploadPhotePasswordView:DUX_UploadUserIconDelegate{
    
    func uploadImageToServer(with image: UIImage!, tag: Int) {
//        self.imageData = UIImagePNGRepresentation(image.mc_reset(to: CGSize(width: 100, height: 100)))
        self.imageData = UIImagePNGRepresentation(image)
        confirmBtn.backgroundColor = SC_ThemeMainColor
        confirmBtn.isUserInteractionEnabled = true
        selectImageBtn.setImage(image, for: .normal)
        
    }
    
    func uploadImageToServer(with image: UIImage!, fileUrl: String!) {
        self.imageURL = fileUrl;
        
    }
    
}
