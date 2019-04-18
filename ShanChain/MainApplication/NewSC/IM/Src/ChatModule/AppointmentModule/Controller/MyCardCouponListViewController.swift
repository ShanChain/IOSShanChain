//
//  MyCardCouponListViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/7.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit


private let H_cell = "AppointmentListCell"

class MyCardCouponListViewController: SCBaseVC {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    public required init(type:MyCardCouponType){
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var page:Int = 1
    let size:String = "10"
    var dataList:[MyCouponsModel] = []
    fileprivate var type:MyCardCouponType?
    fileprivate var controllerPage:WalletPage = WalletPage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("sc_Voucher_MyVoucher", comment: "字符串")
        tableView.estimatedRowHeight = 163
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib.init(nibName: H_cell, bundle: nil), forCellReuseIdentifier: H_cell)
        view.backgroundColor = SC_ThemeBackgroundViewColor
        tableView.backgroundColor = SC_ThemeBackgroundViewColor
        reftreshData()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false;
        };
//        tableBottomConstraint.constant = CGFloat(UIDevice().bottomConstraint)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataList.count == 0{
            tableView.mj_header.beginRefreshing()
        }else{
            self._requstData(false) {}
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension MyCardCouponListViewController{
    
    fileprivate func reftreshData()  {
        tableView.mj_footer = MJRefreshBackNormalFooter {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                print("上拉加载更多数据")
                self?.page += 1
                self?._requstData(true, { [weak self] in
                    
                    if (self?.controllerPage.pageNo)! == (self?.controllerPage.last)!{
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
                self?._requstData(false, { [weak self] in
                    if (self?.controllerPage.pageNo)! == (self?.controllerPage.last)!{
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }else{
                        
                        self?.tableView.mj_footer.resetNoMoreData()
                    }
                    self?.tableView.mj_header.endRefreshing()
                });
            })
        }
        
    }
    
    
    func _getRequstUrl() ->String{
        if type == .receive {
            return User_Receive_List_URL
        }
        return User_Create_List_URL
    }
    
    func _getPrameter() -> Dictionary<String,Any> {
        return ["subuserId":SCCacheTool.shareInstance().getCurrentCharacterId(),"pageNo":page,"pageSize":size]
    }
    
    fileprivate func _requstData(_ isLoad:Bool  , _ complete: @escaping () -> ()){

        SCNetwork.shareInstance().hh_Get(withUrl: _getRequstUrl(), parameters: _getPrameter(), showLoading: false) { (baseModel, error) in
            
            if error != nil{
                complete()
                return
            }
            if let data = baseModel?.data as? Dictionary<String,Any>{
                self.controllerPage =  WalletPage.deserialize(from: data)!
                if let arr = data["list"] as? NSArray{
                    if let datas:[MyCouponsModel] = [MyCouponsModel].deserialize(from: arr) as? [MyCouponsModel]{
                        if (datas.count > 0){
                            if(isLoad){
                                for content in datas{
                                    self.dataList.append(content)
                                }
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
            
            if self.dataList.count == 0{
                self.noDataTipShow(self.tableView, content: NSLocalizedString("sc_Nodata", comment: "字符串"), image: UIImage.loadImage("sc_com_icon_blankPage"), backgroundColor: SC_ThemeBackgroundViewColor)
                self.tableView.isScrollEnabled = false
            }else{
                self.tableView.isScrollEnabled = true
                self.noDataTipDismiss()
            }
            
            complete()
        }
    }
    
}

extension MyCardCouponListViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataList.count > 0 {
            return  dataList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == dataList.count - 1 {
            return 30
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: H_cell, for: indexPath) as! AppointmentListCell
         cell.selectionStyle = .none
        return cell
    }
    
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            guard let cell = cell as? AppointmentListCell else {
                return
            }
            
            let entity = dataList[indexPath.section]
            cell.iconImg._sd_setImage(withURLString: entity.photoUrl, placeholderImage: SC_defaultImage)
            cell.nikeNameLb.text = entity.nikeName
            cell.nameLb.text = entity.tokenSymbol
            
            let mcDate:MCDate = MCDate.init(interval: entity.deadline ?? Date.init().timeIntervalSince1970)
            let dateStr = mcDate.formattedDate(withFormat: "YYYY-MM-dd")
            cell.deadlineLb.text = "有效期至:\(dateStr!)"
            cell.priceLb.text = "￥\(entity.price!)"
            cell.statusLb.text = entity.statusTitle
            cell.receiveNumberLb.text = entity.sendOutNumTitle
//            cell.priceLb.attributedText = NSString.setAttrFirst("￥", color: <#T##UIColor!#>, font: <#T##UIFont!#>, secendString: <#T##String!#>, color: <#T##UIColor!#>, font: <#T##UIFont!#>)
            
            
            if type == .receive {
                cell.receiveNumberLb.isHidden = true
            }
            
            let section:Int = indexPath.section
            if section % 2 == 1 {
                cell.bgIcon.image =  UIImage.init(name: "sc_com_icon_CardPackage_1")
                cell.nameLb.textColor = SC_EmphasisColor
                cell.nikeNameLb.textColor = SC_EmphasisColor
                cell.deadlineLb.textColor = SC_EmphasisColor
                cell.priceLb.textColor = SC_EmphasisColor
                cell.receiveNumberLb.textColor = SC_EmphasisColor
                cell.statusLb.textColor = .white
            }else{
                cell.bgIcon.image =  UIImage.init(name: "sc_com_icon_CardPackage")
                cell.nameLb.textColor = .white
                cell.nikeNameLb.textColor = .white
                cell.deadlineLb.textColor = .white
                cell.priceLb.textColor = .white
                cell.receiveNumberLb.textColor = .white
                cell.statusLb.textColor = SC_ThemeMainColor
            }
            
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let entity = dataList[indexPath.section]
        if self.type == .receive {
            let storyboard = UIStoryboard(name: "MyCardReceiveDetailsViewController", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ReceiveCardID") as? MyCardReceiveDetailsViewController
            vc?.status = entity.couponsStatus!
            vc?.orderId = entity.subCoupId
            pushPage(vc, animated: true)
            
        }else{
            let vc = MyCardDetailsViewController.init(couponsId: entity.couponsId!, tokenSymbol: entity.tokenSymbol!)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
