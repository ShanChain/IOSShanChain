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
    
    @IBOutlet weak var mortgageLb: UILabel!
    
    
    @IBOutlet weak var mortgageSEAT_Lb: UILabel!
    @IBOutlet weak var createBtn: UIButton!
    
    @objc open var timestamp:String = ""
    open var photoUrl:String? //     logohash
    
    // 点击示例
    @IBAction func exampleAction(_ sender: UIButton) {
        let exampleView = CreateCouponExampleView.init(frame: tableView.frame)
        HHTool.mainWindow().addSubview(exampleView)
    }
    
    @IBAction func questionMarkAction(_ sender: UIButton) {
        self.hrShowAlert(withTitle: "", message: "马甲将收取该券发放总价的1%作为抵押，待该券失效后，将全额返回到您的钱包账户中。")
    }
    // 充值
    @IBAction func addMoneyAction(_ sender: UIButton) {
        let walletVC =  MyWalletViewController()
        navigationController?.pushViewController(walletVC, animated: true)
    }
    
    func getParameter() -> Dictionary<String, Any>{
        // "subuserId":SCCacheTool.shareInstance().getCurrentCharacterId()
        // "userId":SCCacheTool.shareInstance().getCurrentUser()
        
        var des:String = ""
        if descriptionTextView.text == "" {
            des = "empty"
        }else{
            des = descriptionTextView.text
        }
        
        return ["amount":numberFid.text!,"deadline":"\(self.timestamp)","detail":des,"name":nameFid.text!,"photoUrl":photoUrl!,"price":priceFid.text!,"subuserId":SCCacheTool.shareInstance().getCurrentCharacterId(),"tokenSymbol":cardFid.text!,"roomId":SCCacheTool.shareInstance().chatRoomId,"userId":SCCacheTool.shareInstance().getCurrentUser()]
        
    }
    
    @IBAction func createAction(_ sender: UIButton) {
        SCNetwork.shareInstance().v1_post(withUrl: CreateCoupons_URL, params:getParameter(), showLoading: true) { (baseModel, error) in
            if error == nil{
                HHTool.showSucess("创建成功")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func clickIcon(_ sender: UITapGestureRecognizer) {
        DUX_UploadUserIcon.shareUploadImage().showActionSheet(inFatherViewController: self, imageTag: 0, delegate: self as DUX_UploadUserIconDelegate)
      
    }
    
    @IBAction func selectTimeAtion(_ sender: UITapGestureRecognizer) {
        let datePicker = YLDatePicker(currentDate: Date(), minLimitDate:MCDate.init(date: Date()).byAddDays(1).date, maxLimitDate: MCDate.init(date: Date()).byAddYears(20).date, datePickerType: .YMD) { [weak self] (date) in
            self?.failureTimeFid.text = date.getString(format: "YYYY-MM-dd")
            self?.view.endEditing(true)
            if self?.timestamp == ""{
                CouponVerificationService.verificationIsCanCreate(self)
            }
            self?.timestamp = String(Int(date.timeIntervalSince1970 * 1000))
           
        }
        datePicker.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("sc_Voucher_Creat", comment: "字符串")
        CouponVerificationService.verificationCouponNameFid(nameFid)
        CouponVerificationService.verificationCardFid(cardFid)
        CouponVerificationService.dynamicCalculationMortgageFreeNumberFid(numberFid, priceFid: priceFid) {[weak self] (mortgageFree) in
            self?.mortgageLb.text = "￥\(String(format: "%.2f", mortgageFree))"
            self?.mortgageSEAT_Lb.text = "= \(String(format: "%.3f", mortgageFree * 0.1)) SEAT"
        }
        _ConfigurationUI()
    }
    
    func _ConfigurationUI(){
        let headImg = SCCacheTool.shareInstance().characterModel.characterInfo.headImg
        icon._sd_setImage(withURLString: headImg)
        self.photoUrl = headImg
        descriptionTextView.placeholder = NSLocalizedString("sc_Voucher_instructions", comment: "字符串")
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setImage(UIImage(named: "nav_btn_back_default"), for: .normal)
        button.addTarget(self, action: #selector(_back), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        createBtn.isEnabled = false
        createBtn.backgroundColor = .lightGray
        
        nameFid.setTintAjust(10)
        cardFid.setTintAjust(10)
        priceFid.setTintAjust(10)
        numberFid.setTintAjust(10)
        failureTimeFid.setTintAjust(10)
    }
    func _back(){
        navigationController?.popViewController(animated: true)
    }
    
    override func navigationShouldPopOnBackButton() -> Bool {
        var  isClose:Bool = false
        self.hrShowAlert(withTitle: nil, message: "放弃创建马甲吗？", buttonsTitles: [NSLocalizedString("sc_back", comment: "字符串"),NSLocalizedString("sc_confirm", comment: "字符串")]) { (_, index) in
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

