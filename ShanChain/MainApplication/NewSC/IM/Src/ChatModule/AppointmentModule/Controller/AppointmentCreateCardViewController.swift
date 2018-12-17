//
//  AppointmentCreateCardViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/6.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class AppointmentCreateCardViewController: UITableViewController {
    
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var nameFid: UITextField!
    
    @IBOutlet weak var cardFid: UITextField!
    
    
    @IBOutlet weak var priceFid: UITextField!
    
    @IBOutlet weak var numberFid: UITextField!
    
    @IBOutlet weak var failureTimeFid: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    private var timestamp = Date().timeStamp
    fileprivate var photoUrl:String? //     logohash
    
    // 点击示例
    @IBAction func exampleAction(_ sender: UIButton) {
    }
    
    // 充值
    @IBAction func addMoneyAction(_ sender: UIButton) {
        let walletVC =  MyWalletViewController()
        navigationController?.pushViewController(walletVC, animated: true)
    }
    
    
    func getParameter() -> Dictionary<String, Any>{
        return ["amount":numberFid.text!,"deadline":"\(self.timestamp)","detail":descriptionTextView.text!,"name":nameFid.text!,"photoUrl":photoUrl!,"price":priceFid.text!,"subuserId":SCCacheTool.shareInstance().getCurrentCharacterId(),"tokenSymbol":cardFid.text!,"roomId":SCCacheTool.shareInstance().chatRoomId,"userId":SCCacheTool.shareInstance().getCurrentUser()]
    }
    
    @IBAction func createAction(_ sender: UIButton) {
        if _verification() {
            SCNetwork.shareInstance().v1_post(withUrl: CreateCoupons_URL, params:self.getParameter(), showLoading: true) { (baseModel, error) in
                
            }
        }
    }
    
    @IBAction func clickIcon(_ sender: UITapGestureRecognizer) {
        DUX_UploadUserIcon.shareUploadImage().showActionSheet(inFatherViewController: self, imageTag: 0, delegate: self as DUX_UploadUserIconDelegate)
      
    }
    
    
    @IBAction func selectTimeAtion(_ sender: UITapGestureRecognizer) {
        let datePicker = YLDatePicker(currentDate: Date(), minLimitDate:MCDate.init(date: Date()).byAddDays(1).date, maxLimitDate: MCDate.init(date: Date()).byAddYears(20).date, datePickerType: .YMDHm) { [weak self] (date) in
            self?.failureTimeFid.text = date.getString(format: "YYYY-MM-dd HH:mm")
            self?.view.endEditing(true)
            self?.timestamp = String(Int(date.timeIntervalSince1970))
        }
        datePicker.show()
    }
    
    func _verification() -> Bool {
        if (self.photoUrl?.isEmpty)!{
            HHTool.showError("logo不能为空")
            return false
        }
        if (self.nameFid.text?.isEmpty)!{
            HHTool.showError("请输入名称")
            return false
        }
        if (self.cardFid.text?.isEmpty)!{
            HHTool.showError("请输入代号")
            return false
        }
        
        if (self.priceFid.text?.isEmpty)!{
            HHTool.showError("请输入单价")
            return false
        }
        
        if (self.numberFid.text?.isEmpty)!{
            HHTool.showError("请输入发布数量")
            return false
        }
        
        if (self.failureTimeFid.text?.isEmpty)!{
            HHTool.showError("失效时间不能为空")
            return false
        }
        
        if (self.descriptionTextView.text?.isEmpty)!{
            HHTool.showError("说明不能为空")
            return false
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "创建马甲劵"
        descriptionTextView.placeholder = "请具体描述该劵的使用说明，如联系电话、地址、金额限制等"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }

    override func navigationShouldPopOnBackButton() -> Bool {
        var  isClose:Bool = false
        self.hrShowAlert(withTitle: nil, message: "放弃创建马甲吗？", buttonsTitles: ["返回","确认"]) { (_, index) in
            if index == 1{
                isClose = true
                self.navigationController?.popViewController(animated: true)
            }
        }
        return  isClose
    }
    
}


extension AppointmentCreateCardViewController:DUX_UploadUserIconDelegate{
    
    func uploadImageToServer(with image: UIImage!, tag: Int) {
        if let image = image{
            image.mc_reset(to: CGSize(width: 80, height: 80))
            image.cutCircle()
            SCAliyunUploadMananger.uploadImage(image, withCompressionQuality: 0.5, withCallBack: { url in
                self.photoUrl = url
                self.icon.image = image
            }, withErrorCallBack: { error in
                HHTool.showError(error?.localizedDescription)
            })
        }
        
    }
    
}

