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
    @objc var closure:UploadSuccessClosure?
    var imageData:Data?
    var imageURL:String?
    @objc var imageViewTag:Int = 0
    
    @objc var vc:UIViewController?
    @objc var transferDic: Dictionary<String, Any>?
    @objc var isTransfer:Bool = false
    
    
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var selectImageBtn: UIButton!
    //    convenience init(listModel:TaskListModel,frame:CGRect) {
//        self.init(frame: frame)
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        imageViewTag = 0
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
        
        HHTool.immediatelyDismiss()//取消掉业务菊花
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction func confirmAction(_ sender: Any) {
        
        
        // 验证密码是否正确        

        let registrationID:String = JPUSHService.registrationID() ?? ""
        SCNetwork.shareInstance().hh_uploadFile(withArr: [self.imageURL ?? ""], url: CreateAuthCode_URL, parameters: ["deviceToken":registrationID], showLoading: true, call: { (baseModel, error) in
            
            if let authCode  = baseModel?.data , ((baseModel?.data as? String) != nil){
                if self.imageViewTag == 214 && self.isTransfer {
                    // 将原本H5做得请求放在原生做
                    self.removeFromSuperview()
                    self.transferHandle()
                    
                    
                }else {
                    if SCCacheTool.shareInstance().characterModel.characterInfo.isBindPwd != true{
                        self.vc?.sc_hrShowAlert(withTitle: "验证成功！", message: "您也可以选择开启免密功能，在下次使用马甲券时便无需再次上传安全码，让使用更加方便快捷，是否开通免密功能？", buttonsTitles: ["暂不需要","立即开通"], andHandler: { (_, index) in
                            if index == 1{
                                // 开通免密
                                EditInfoService.sc_editPersonalInfo(["bind":true], call: { (isSuccess) in
                                    if isSuccess == true{
                                        HHTool.showSucess("开通成功!")
                                        SCCacheTool.shareInstance().setCacheValue(authCode as! String, withUserID:  SCCacheTool.shareInstance().getCurrentUser(), andKey: SC_AUTHCODE)
                                    }
                                })
                            }
                            self.closure!(true,authCode as! String)
                        })
                    }else{
                        SCCacheTool.shareInstance().setCacheValue(authCode as! String, withUserID:  SCCacheTool.shareInstance().getCurrentUser(), andKey: SC_AUTHCODE)
                        self.closure!(true,authCode as! String)
                    }
                }
                
                
            }
        })
    }

    
    @IBAction func uploadAction(_ sender: UIButton) {
        DUX_UploadUserIcon.shareUploadImage().showActionSheet(inFatherViewController: self.vc, imageTag: self.imageViewTag, delegate: self as DUX_UploadUserIconDelegate)
    }
    
    func transferHandle() {
        
        // 转账数据
        
        guard var tmpTransferDic = transferDic else {
            print("数据有问题")
            return
        }
        
        var tmp: String = ""
        var url: String = ""
        tmpTransferDic["file"] = self.imageURL
        
        
        let operationType = tmpTransferDic["operationType"] as! String
        tmpTransferDic.removeValue(forKey: "operationType")
        
        if operationType == "PostSale"{
            // 发布 出售
            tmp = String(format: "&imgHashValue=%@&orderDesc=%@", tmpTransferDic["imgHashValue"]as! String,tmpTransferDic["orderDesc"]as! String)
            tmpTransferDic.removeValue(forKey: "imgHashValue")
            tmpTransferDic.removeValue(forKey: "orderDesc")
            url = String(format: "/wallet/api/exchange/sell/pendingOrder/create?token=%@%@", SCCacheTool.shareInstance().getUserToken(),tmp)
        }else if operationType == "DigitalAssets" {
            // 发起委托交易
            url = String(format: "/wallet/api/exchange/cointrade/order/save?token=%@", SCCacheTool.shareInstance().getUserToken())
        }else if operationType == "LiftBond" {
            // 提券
            url = String(format: "/wallet/api/exchange/cointrade/withdraw?token=%@", SCCacheTool.shareInstance().getUserToken())
        }else if operationType == "SellComfirmedList" {
            // 确认出售
            tmp = String(format: "&imgHashValue=%@&orderDesc=%@", tmpTransferDic["imgHashValue"]as! String,tmpTransferDic["orderDesc"]as! String)
            tmpTransferDic.removeValue(forKey: "imgHashValue")
            tmpTransferDic.removeValue(forKey: "orderDesc")
            url = String(format: "/wallet/api/buy/order/confirm?token=%@%@", SCCacheTool.shareInstance().getUserToken(),tmp)
        }else if operationType == "Transfer" {
            // 转账
            tmp = tmpTransferDic["data"] as! String
            tmpTransferDic.removeValue(forKey: "data")
            tmpTransferDic.removeValue(forKey: "transferType")
            url = String(format: "/wallet/api/wallet/2.0/creatTransaction?token=%@%@", SCCacheTool.shareInstance().getUserToken(),tmp)
        }
        // 判断 url 是否有中文
        if HHTool.checkIsChinese(url) {
            url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        print(url,tmpTransferDic)
        SCNetwork.shareInstance().transfer(withUrl: url, data: tmpTransferDic, block: { (result, bool) in
            if (bool) {
                let r = result as! Dictionary<String, Any>
                let code = r["code"]
                let formatter = NumberFormatter()
                formatter.minimumIntegerDigits = 2
                let tmp = formatter.string(from: code as! NSNumber)
                self.closure!(true,tmp!)
                return
                
            }
        })
    }
}


extension UploadPhotePasswordView:DUX_UploadUserIconDelegate{
    
    func uploadImageToServer(with image: UIImage!, tag: Int, imageData data: Data!) {
        self.imageData = image.pngData()
        confirmBtn.backgroundColor = SC_ThemeMainColor
        confirmBtn.isUserInteractionEnabled = true
        selectImageBtn.setImage(image, for: .normal)
    }
//    func uploadImageToServer(with image: UIImage!, tag: Int) {
////        self.imageData = UIImagePNGRepresentation(image.mc_reset(to: CGSize(width: 100, height: 100)))
//        self.imageData = image.jpegData(compressionQuality: 1.0)
//        confirmBtn.backgroundColor = SC_ThemeMainColor
//        confirmBtn.isUserInteractionEnabled = true
//        selectImageBtn.setImage(image, for: .normal)
//        
//    }
    
    func uploadImageToServer(with image: UIImage!, fileUrl: String!) {
        self.imageURL = fileUrl;
    }
    
}
