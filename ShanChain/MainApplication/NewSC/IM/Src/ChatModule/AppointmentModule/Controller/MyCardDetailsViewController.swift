//
//  MyCardDetailsViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/10.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

private let H_cell = "AppointmentCardDetialsCell"

class MyCardDetailsViewController: SCBaseVC {

    
    @IBOutlet var tableHeaderView: UIView!
    
    @IBOutlet weak var header_icon: UIImageView!
    
    @IBOutlet weak var header_nikeNameLb: UILabel!
    
    @IBOutlet weak var header_cardLb: UILabel!
    

    @IBOutlet weak var header_priceLb: UILabel!
    
    
    @IBOutlet weak var header_totalLb: UILabel!
    
    
    @IBOutlet weak var header_releaseTimeLb: UILabel!
    
    
    @IBOutlet weak var header_ruleLb: UILabel!
    
    @IBOutlet weak var deadlineLb: UILabel!
    
    @IBOutlet weak var header_waitLb: UILabel!
    
    
    @IBOutlet weak var header_completeLb: UILabel!
    
    
    @IBOutlet weak var header_laveLB: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var invalidIcon: UIImageView!
    
    var couponsId:String? // 卡劵ID
    var tokenSymbol:String? // 卡劵代号
    var couponsModel:CouponsEntityModel?
    
    var page:Int = 1
    let size:String = "10"
    var dataList:[CouponsEntityModel] = []
    fileprivate var controllerPage:WalletPage?
    
    func _ConfigurationHeaderViewUI(){
       
       tableView.reloadData()
       // tableView.tableHeaderView = tableHeaderView
        header_icon._sd_setImage(withURLString: couponsModel?.photoUrl, placeholderImage: SC_defaultImage)
        header_cardLb.text = couponsModel?.tokenSymbol
        header_nikeNameLb.text = couponsModel?.name
        header_priceLb.text = "￥\(couponsModel?.price ?? "0")"
        header_totalLb.text = "共\(couponsModel?.amount ?? "0")张"
        invalidIcon.isHidden = !(couponsModel?.isMainInvalid)!
        let mcDate:MCDate = MCDate.init(interval: (couponsModel?.createTime)!/1000)
        let dateStr = mcDate.formattedDate(withFormat: "YYYY-MM-dd")
        header_releaseTimeLb.text = dateStr
        header_ruleLb.text = couponsModel?.detail
        
        let deadlineDate:MCDate = MCDate.init(interval: (couponsModel?.deadline)!/1000)
        let deadlineStr = deadlineDate.formattedDate(withFormat: "YYYY-MM-dd")
        deadlineLb.text = "有效期至:\(deadlineStr!)"
        header_waitLb.text = "待核销:\(couponsModel?.unusedNum ?? "0")张"
        header_completeLb.text = "已核销:\(couponsModel?.usedNum ?? "0")张"
        header_laveLB.text = "剩余:\(couponsModel?.remainAmount ?? "0")张"
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
      //  tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 50
        tableView.register(UINib.init(nibName: H_cell, bundle: nil), forCellReuseIdentifier: H_cell)
        title = "马甲劵详情"
        reftreshData()
        _requstDetaisData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataList.count == 0{
            tableView.mj_header.beginRefreshing()
        }
    }
    
    
    public required init(couponsId:String,tokenSymbol:String) {
        self.couponsId = couponsId
        self.tokenSymbol = tokenSymbol
        super.init(nibName: "MyCardDetailsViewController", bundle: nil) // 加载xib视图
        automaticallyAdjustsScrollViewInsets = false;

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension MyCardDetailsViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList.count > 0 {
            return  dataList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if couponsModel == nil {
            return 135
        }
       
        return (couponsModel?.detail?.heightForAdaptive(Font: Font(17), CGFloat(SCREEN_WIDTH - 60)))! + 165
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: H_cell, for: indexPath) as! AppointmentCardDetialsCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            guard let cell = cell as? AppointmentCardDetialsCell else {
                return
            }
        let entity = dataList[indexPath.row]
        cell.nikeNameLb.text = entity.userId
//        cell.icon._sd_setImage(withURLString: entity.photoUrl, placeholderImage: UIImage.loadImage("DefaultAvatar"))
        cell.timeLb.text = entity.getTimeStr
        cell.statusLb.text = entity.recipientStatusTitle;
    }
    
}

extension  MyCardDetailsViewController{
    
    fileprivate func reftreshData()  {
        tableView.mj_footer = MJRefreshBackNormalFooter {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
              
                self?._requstClientlDetailsWithTokenSymbol(true, {
                    if (self?.controllerPage?.pageNo)! == (self?.controllerPage?.last)!{
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }else{
                        self?.tableView.mj_footer.endRefreshing()
                    }
                })
                
            })
        }
        tableView.mj_header = MJRefreshNormalHeader {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                print("下拉刷新 --- 1")
                self?.page = 1
                self?._requstClientlDetailsWithTokenSymbol(false, {
                    if (self?.controllerPage?.pageNo)! == (self?.controllerPage?.last)!{
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }else{
                        self?.tableView.mj_footer.resetNoMoreData()
                    }
                    self?.tableView.mj_header.endRefreshing()
                })
            })
        }
        
    }
    
    
    func _requstClientlDetailsWithTokenSymbol(_ isLoad:Bool , _ complete: @escaping () -> ()){
        
        let index = self.tokenSymbol!.index(self.tokenSymbol!.startIndex, offsetBy: 3)
        SCNetwork.shareInstance().hh_Get(withUrl: User_ClientList_URL, parameters: ["tokenSymbol":self.tokenSymbol!.substring(to: index),"pageNo":self.page,"pageSize":self.size], showLoading: true) { (baseModel, error) in
            if error != nil{
                complete()
                return
            }
            
            if let data = baseModel?.data as? Dictionary<String,Any>{
                 self.controllerPage =  WalletPage.deserialize(from: data)
                if let arr = data["list"] as? NSArray{
                    if let datas:[CouponsEntityModel] = [CouponsEntityModel].deserialize(from: arr) as? [CouponsEntityModel]{
                        if (datas.count > 0){
                            if(isLoad){
                                for content in datas{
                                    self.dataList.append(content)
                                }
                                self.page += 1
                            }else{
                                self.dataList = datas
                            }
                            self.tableView.reloadData()
                        }else{
                            if isLoad == false{
                                self.dataList.removeAll()
                            }
                            self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        }
                        
                    }
                }
            }
            complete()
        }
        
    }
    
    func _requstDetaisData(){
        SCNetwork.shareInstance().hh_Get(withUrl: CouponsVendorDetails_URL, parameters: ["couponsId":self.couponsId], showLoading: true) {[weak self] (baseModel, error) in
            if let data = baseModel?.data as? Dictionary<String,Any>{
                if let model = CouponsEntityModel.deserialize(from: data){
                    self?.couponsModel = model;
                    self?._ConfigurationHeaderViewUI()
//                    SCNetwork.shareInstance().v1_post(withUrl: "/v1/character/get/current", params: ["userId":model.userId], showLoading: true, call: { (userModel, error) in
//                        if let userDic = userModel?.data as? [String:Any]{
//                            if let characterInfo = userDic["characterInfo"] as? [String:Any]{
//                                let nikeName:String = characterInfo["name"] as! String
//                                self.header_nikeNameLb.text = nikeName
//                                self._ConfigurationHeaderViewUI()
//                            }
//                        }
//                    })
                    
                }
            }
        }
    }
    
}





