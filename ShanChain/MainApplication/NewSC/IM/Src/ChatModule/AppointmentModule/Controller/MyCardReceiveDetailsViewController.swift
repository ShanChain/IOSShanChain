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
    
    
    @IBOutlet weak var remainderLb: UILabel!
    var status:CouponsStatus = .receive_Wait
    @objc open  var orderId:String?
    @objc open  var isUseCouponsing:Bool = false // 是否正在核销当前子卡劵
    
    var detailsModel:CouponsDetailsModel?

    @IBAction func applyAction(_ sender: UIButton) {
        switch status{
            
        case .create_Wait:
            let index = self.detailsModel?.tokenSymbol!.index((self.detailsModel?.tokenSymbol!.startIndex)!, offsetBy: 3)
            SCNetwork.shareInstance().hh_Get(withUrl: ReceiveCoupons_URL, parameters: ["quantities":"1","subuserId":SCCacheTool.shareInstance().getCurrentUser(),"tokenSymbol":self.detailsModel?.tokenSymbol?.substring(to: index!),"userId":self.detailsModel?.userId], showLoading: true) { (baseModel, error) in
                if error == nil{
                    HHTool.showSucess("领取成功")
                    self.navigationController?.popViewController(animated: true)
                }
            }
            break
        case .receive_Wait:
            if isUseCouponsing == true{
                // 核销马甲劵
                SCNetwork.shareInstance().hh_Get(withUrl: User_UseCoupons_URL, parameters: ["subCoupId":self.detailsModel?.subCoupId], showLoading: true) { (baseModel, error) in
                    
                }
            }else{
                let  scanCodeVC = MyCardScanCodeDetailsViewController()
                scanCodeVC.detailsModel = detailsModel
                navigationController?.pushViewController(scanCodeVC, animated: true)
            }
          
            break
        default: break
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func _back(){
        navigationController?.popViewController(animated: true)
    }
    
    func _configurationUI(){
        self.icon._sd_setImage(withURLString: self.detailsModel?.photoUrl, placeholderImage:UIImage.loadImage(DefaultAvatar))
        self.titleLb.text = detailsModel?.tokenName
        self.cardLb.text = detailsModel?.tokenSymbol
        self.userNameLb.text = detailsModel?.nikeName
        self.priceLb.text = "￥\(detailsModel?.price ?? "")"
        self.remainderLb.text = "剩余\(detailsModel?.remainAmount ?? "0")张"
        if  detailsModel?.remainAmount == nil {
            self.remainderLb.isHidden = true
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
            statusTitle = "已使用"
            break
        case .receive_Invalid:
            NSDate.chatingTime("1")
            statusTitle = "已失效\(MCDate.init(interval: TimeInterval(Int((detailsModel?.getTime!)!)!)).formattedDate(withFormat: "YYYY-MM-dd"))"
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
            if  let dic = baseModel?.data as? Dictionary<String,Any>{
                self.detailsModel = CouponsDetailsModel.deserialize(from: dic)
                SCNetwork.shareInstance().v1_post(withUrl: "/v1/character/get/current", params: ["userId":self.detailsModel?.userId], showLoading: isShow, call: { (userModel, error) in
                    if let userDic = userModel?.data as? [String:Any]{
                        if let characterInfo = userDic["characterInfo"] as? [String:Any]{
                            let nikeName:String = characterInfo["name"] as! String
                            self.detailsModel?.nikeName = nikeName
                            self._configurationUI()
                        }
                        
                    }
                   
                })
    
            }
        }
    }
}
