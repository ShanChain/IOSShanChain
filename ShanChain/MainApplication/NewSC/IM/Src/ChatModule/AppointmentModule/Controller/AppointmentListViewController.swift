//
//  AppointmentListViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/6.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit


private let H_cell = "AppointmentListCell"

class AppointmentListViewController: SCBaseVC {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var headView: UIView!
    
    @IBOutlet weak var createBtn: UIButton!
    
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    var page:Int = 1
    let size:String = "10"
    var dataList:[CouponsEntityModel] = []
    fileprivate var controllerPage:WalletPage = WalletPage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("sc_Voucher_MarJar", comment: "字符串")
        createBtn.setTitle(NSLocalizedString("sc_Voucher_Creat", comment: "字符串"), for: .normal)
//        tableView.tableHeaderView = headView
//        tableView.tableHeaderView?.backgroundColor = SC_ThemeBackgroundViewColor
        view.addSubview(headView)
        
        tableBottomConstraint.constant = CGFloat(UIDevice().bottomConstraint)
        headView.snp.makeConstraints { (mk) in
            mk.left.right.equalTo(0)
            mk.top.equalTo(self.topLayoutGuide.snp.bottom)
            mk.height.equalTo(50)
        }
        
        
        tableView.estimatedRowHeight = 163
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib.init(nibName: H_cell, bundle: nil), forCellReuseIdentifier: H_cell)
        tableView.backgroundColor = SC_ThemeBackgroundViewColor
        self.addRightBarButtonItem(withTarget: self, sel: #selector(_clickMy), title:NSLocalizedString("sc_Voucher_My", comment: "字符串"), tintColor: .black)
        view.backgroundColor = SC_ThemeBackgroundViewColor
        headView.backgroundColor = SC_ThemeBackgroundViewColor
       
        reftreshData()
        extendedLayoutIncludesOpaqueBars = true;
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false;
        };
        self.tableView.contentInset = UIEdgeInsetsMake(CGFloat(UIDevice().navBarHeight), 0, CGFloat(UIDevice().tabBarHeight), 0)
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        
    }
    
    func _clickMy(){
        let vc = MyCardCouponContainerViewController()
        navigationController?.pushViewController(vc, animated: true)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataList.count == 0{
            tableView.mj_header.beginRefreshing()
        }else{
            self._requstData(false) {}
        }
    }
    
    @IBAction func createAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AppointmentCreateCardViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateCardID") as? AppointmentCreateCardViewController
        pushPage(vc, animated: true)
    }
    
}

extension AppointmentListViewController{
    
    fileprivate func reftreshData()  {
        tableView.mj_footer = MJRefreshBackNormalFooter {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                print("上拉加载更多数据")
                self?._requstData(true, { [weak self] in
                    
                    if (self?.controllerPage.pageNo)! == (self?.controllerPage.last)!{
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }else{
                        self?.tableView.mj_footer.endRefreshing()
                    }
                })
                
            })
        }
        tableView.mj_footer.ignoredScrollViewContentInsetBottom = CGFloat(UIDevice().tabBarHeight)
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
    
    fileprivate func _requstData(_ isLoad:Bool  , _ complete: @escaping () -> ()){
        
        SCNetwork.shareInstance().hh_Get(withUrl: CouponsVendorList_URL, parameters: _requstPrameter(isLoad), showLoading: false) { (baseModel, error) in
            if error != nil{
                complete()
                return
            }
            
            if let data = baseModel?.data as? Dictionary<String,Any>{
                self.controllerPage =  WalletPage.deserialize(from: data)!
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

            if self.dataList.count == 0{
                self.noDataTipShow(self.tableView, content: NSLocalizedString("sc_Nodata", comment: "字符串"), image: UIImage.loadImage("sc_com_icon_blankPage"), backgroundColor: SC_ThemeBackgroundViewColor)
                self.tableView.isScrollEnabled = false
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }else{
                self.tableView.isScrollEnabled = true
                self.noDataTipDismiss()
               
            }
            
            complete()
        }
        
    }
    
    
    fileprivate func _requstPrameter(_ isLoad:Bool) -> Dictionary<String, Any> {
        let pageStr = isLoad ? page+1:page
        return  ["roomId":SCCacheTool.shareInstance().chatRoomId,"pageSize":size,"pageNo":pageStr,"subuserId":SCCacheTool.shareInstance().getCurrentCharacterId()]
    }
   
    
}

extension AppointmentListViewController:UITableViewDataSource,UITableViewDelegate{
    
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
        cell.nikeNameLb.text = entity.name
        cell.nameLb.text = entity.tokenSymbol
        let mcDate:MCDate = MCDate.init(interval: entity.deadline/1000)
        let dateStr = mcDate.formattedDate(withFormat: "YYYY-MM-dd")
        cell.deadlineLb.text = "有效期至:\(dateStr!)"
        cell.priceLb.text = "￥\(entity.price!)"
        cell.statusLb.text = entity.listStatusTitle
        cell.receiveNumberLb.text = entity.remainAmountTitle
        
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
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let entity = dataList[indexPath.section]
        if entity.userId == SCCacheTool.shareInstance().getCurrentUser(){
            // 我是创建方
            let myCardDetailsVC = MyCardDetailsViewController.init(couponsId: entity.couponsId!, tokenSymbol: entity.tokenSymbol!)
            pushPage(myCardDetailsVC, animated: true)
            
        }else{
            //别人创建的
            let storyboard = UIStoryboard(name: "MyCardReceiveDetailsViewController", bundle: nil)
            let detailsVC = storyboard.instantiateViewController(withIdentifier: "ReceiveCardID") as? MyCardReceiveDetailsViewController
            detailsVC?.status = entity.couponsStatus!
            detailsVC?.orderId = entity.couponsId
            pushPage(detailsVC, animated: true)
        }
        
        
    }
    
}
