//
//  MyCardReceiveDetailsViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/11.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit



class MyCardReceiveDetailsViewController: UITableViewController {

    @IBOutlet weak var icon: UIImageView!
    
    
    @IBOutlet weak var userNameLb: UILabel!
    
    
    @IBOutlet weak var priceLb: UILabel!
    
    
    @IBOutlet weak var titleLb: UILabel!
    
    
    @IBOutlet weak var cardLb: UILabel!
    
    
    @IBOutlet weak var ruleLb: UILabel!
    
    
    @IBOutlet weak var dealTimeLb: UILabel!
    
    
    @IBOutlet weak var statusBtn: UIButton!
    
    
    @IBOutlet weak var ruleTitleLb: UILabel!
    @IBOutlet weak var remainderLb: UILabel!
    var status:CouponsStatus = .receive_Wait
    @objc open  var orderId:String?
    @objc open  var couponsToken:String? //核销凭证
    @objc open  var isUseCouponsing:Bool = false // 是否正在核销当前子卡劵
    
    var hxUserName:String? //极光用户名
    
    
    var detailsModel:CouponsDetailsModel?

    @IBAction func headAction(_ sender: UIButton) {
        //
        if let userName = self.hxUserName {
            
            JMSGConversation.createSingleConversation(withUsername: userName) { (result, error) in
                if error == nil {
                    ChatPublicService.jg_addFriendFeFocus(funsJmUserName: userName)
                    let conv = result as! JMSGConversation
                    let vc = JCChatViewController(conversation: conv)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateConversation), object: nil, userInfo: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    @IBAction func applyAction(_ sender: UIButton) {
        switch status{
            
        case .create_Wait:
            let index = self.detailsModel?.tokenSymbol!.index((self.detailsModel?.tokenSymbol!.startIndex)!, offsetBy: 3)
            SCNetwork.shareInstance().hh_Get(withUrl: ReceiveCoupons_URL, parameters: ["quantities":"1","subuserId":SCCacheTool.shareInstance().getCurrentCharacterId(),"tokenSymbol":self.detailsModel?.tokenSymbol?.substring(to: index!),"userId":SCCacheTool.shareInstance().getCurrentUser()], showLoading: true) { (baseModel, error) in
                if error != nil{
                    return
                }
                if let data = baseModel?.data as? Dictionary<String,Any>{
                    if let subCoupId = data["subCoupId"] as? String{
                        self.status = .receive_Wait
                        self.orderId = subCoupId
                        self._requstDetaisData(isShow: true)
                    }
                }
            }
            break
        case .receive_Wait:
            if isUseCouponsing == true{
                // 核销马甲劵
                SCNetwork.shareInstance().hh_Get(withUrl: User_UseCoupons_URL, parameters: ["couponsToken":couponsToken], showLoading: true) { (baseModel, error) in
                    if error != nil{
                        var message:String = "识别失败"
                        if (error as NSError?)?.code == 10050{
                            message = "很抱歉，您无法核销他人创建的马甲券，尝试创建自己的马甲券吧～"
                        }
                        self.hrShowAlert(withTitle: nil, message: message, buttonsTitles: ["我知道了"], andHandler: { (_, _) in
                            self.pop(toViewControllerClass: MyCardCouponContainerViewController.self, withAnimation: true)
                        })
                        return
                    }
                    
                    self._requstDetaisData(isShow: true)
                }

            }else{
                _getCouponsToken { (createQR_jsonStr) in
                    let  scanCodeVC = MyCardScanCodeDetailsViewController()
                    scanCodeVC.createQR_jsonStr = createQR_jsonStr
                    scanCodeVC.detailsModel = self.detailsModel
                    self.navigationController?.pushViewController(scanCodeVC, animated: true)
                }
                
            }
          
            break
        default: break
            
        }
    }
    
    // 获取子卡劵的核销凭证
    func _getCouponsToken(_ complete: @escaping (_ createQR_jsonStr:String) -> ()){
        SCNetwork.shareInstance().hh_Get(withUrl: GetCouponsToken_URL, parameters: ["authCode":SCCacheTool.shareInstance().getAuthCode(),"deviceToken":SCCacheTool.shareInstance().getDeviceToken(),"subCoupId":self.detailsModel?.subCoupId], showLoading: true) { (baseModel, error) in
            if let data = baseModel?.data as? NSDictionary{
               complete(data.mj_JSONString())
            }else{
                complete("")
            }
            
        }
    }
    
    func _isHiddenSubView(_ isHidden:Bool){
        icon.isHidden = isHidden
        userNameLb.isHidden = isHidden
        priceLb.isHidden = isHidden
        titleLb.isHidden = isHidden
        cardLb.isHidden = isHidden
        ruleLb.isHidden = isHidden
        statusBtn.isHidden = isHidden
        remainderLb.isHidden = isHidden
        ruleTitleLb.isHidden = isHidden
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _isHiddenSubView(true)
        _requstDetaisData(isShow: true)
        self.icon.preventImageViewExtrudeDeformation()
        title = NSLocalizedString("sc_Voucher_Voucherinformation", comment: "字符串")
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setImage(UIImage(named: "nav_btn_back_default"), for: .normal)
        button.addTarget(self, action: #selector(_back), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
    }

 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func _back(){
        navigationController?.popViewController(animated: true)
    }
    
    func _configurationUI(){
        self.icon._sd_setImage(withURLString: self.detailsModel?.photoUrl, placeholderImage:UIImage.loadImage(DefaultAvatar))
        self.titleLb.text = detailsModel?.tokenName ?? detailsModel?.name
        self.cardLb.text = detailsModel?.tokenSymbol
        self.userNameLb.text = detailsModel?.nikeName
        self.priceLb.text = "￥\(detailsModel?.price ?? "")"
        self.remainderLb.text = "剩余\(detailsModel?.remainAmount ?? "0")张"
        if  detailsModel?.remainAmount == nil {
            self.remainderLb.isHidden = true
        }else{
            self.remainderLb.isHidden = false
        }
        
        var statusTitle = "立刻领取"
        switch status{
        case .receive_Wait:
            if isUseCouponsing == true{
                statusTitle = "核销马甲劵"
            }else{
                statusTitle = "立刻使用"
            }
            
            break
        case .receive_Complete:
            
            let mcDate:MCDate = MCDate.init(interval: ((detailsModel?.useTime)! / 1000))
            let dateStr = mcDate.formattedDate(withFormat: "YYYY-MM-dd")
            if isUseCouponsing == true{
                statusTitle = "已核销 \(dateStr!)"
            }else{
                statusTitle = "已使用 \(dateStr!)"
            }
            statusBtn.backgroundColor = .gray
            break
        case .receive_Invalid:
            
            let mcDate:MCDate = MCDate.init(interval: ((detailsModel?.getTime)! / 1000))
            let dateStr = mcDate.formattedDate(withFormat: "YYYY-MM-dd")
            
            if isUseCouponsing == true{
                statusTitle = "该劵已失效"
            }else{
                statusTitle = "已失效\(dateStr!)"
            }
             statusBtn.backgroundColor = .gray
            break
        default: break
            
        }
        statusBtn.setTitle(statusTitle, for: .normal)
        self.ruleLb.text = detailsModel?.detail
        let mcDate:MCDate = MCDate.init(interval: ((detailsModel?.deadline)! / 1000))
        let dateStr = mcDate.formattedDate(withFormat: "YYYY-MM-dd")
        self.dealTimeLb.text = "有效期至:\(dateStr!)"
    }


}


extension MyCardReceiveDetailsViewController{
    func _requstDetaisData(isShow:Bool){
        var url:String = ""
        var parameter:Dictionary<String,Any> = [:]
        if status == .create_Wait {
            url = CouponsVendorDetails_URL
            parameter = ["couponsId":orderId!]
        }else{
            url = User_Receive_Details
            parameter = ["subCoupId":orderId!]
        }
        SCNetwork.shareInstance().hh_Get(withUrl: url, parameters: parameter, showLoading: isShow) { (baseModel, error) in
            if error != nil{
                return
            }
            if  let dic = baseModel?.data as? Dictionary<String,Any>{
                self.detailsModel = CouponsDetailsModel.deserialize(from: dic)
                if self.isUseCouponsing == true{
                  
                    if self.detailsModel?.vendorUser != SCCacheTool.shareInstance().getCurrentUser(){
                        let message:String = "很抱歉，您无法核销他人创建的马甲券，尝试创建自己的马甲券吧～"
                        self.hrShowAlert(withTitle: nil, message: message, buttonsTitles: ["我知道了"], andHandler: { (_, _) in
                            self.pop(toViewControllerClass: MyCardCouponContainerViewController.self, withAnimation: true)
                        })
                        return
                    }else{
                          self.status = (self.detailsModel?.couponsStatus)!
                    }
                }
                SCNetwork.shareInstance().v1_post(withUrl: "/v1/character/get/current", params: ["userId":self.detailsModel?.vendorUserStr], showLoading: isShow, call: { (userModel, error) in
                    if let userDic = userModel?.data as? [String:Any]{
                        if let characterInfo = userDic["characterInfo"] as? [String:Any]{
                            let nikeName:String = characterInfo["name"] as! String
                            self.detailsModel?.nikeName = nikeName
                            self._isHiddenSubView(false)
                            self._configurationUI()
                     
                        }
                        let account = userDic["hxAccount"] as? [String : Any]
                        self.hxUserName = (account?["hxUserName"] as! String)

                        
                    }
                    
                    
                })
    
            }
        }
    }
}
