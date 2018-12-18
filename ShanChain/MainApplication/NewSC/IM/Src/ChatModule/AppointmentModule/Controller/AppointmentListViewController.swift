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
    
    var page:Int = 1
    let size:String = "10"
    var dataList:[CouponsEntityModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "马甲劵"
//        tableView.tableHeaderView = headView
//        tableView.tableHeaderView?.backgroundColor = SC_ThemeBackgroundViewColor
        view.addSubview(headView)
        

        headView.snp.makeConstraints { (mk) in
            mk.left.right.equalTo(0)
            mk.top.equalTo(UIDevice().navBarHeight)
            mk.height.equalTo(50)
        }
        
        
        tableView.estimatedRowHeight = 163
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib.init(nibName: H_cell, bundle: nil), forCellReuseIdentifier: H_cell)
        tableView.backgroundColor = SC_ThemeBackgroundViewColor
        self.addRightBarButtonItem(withTarget: self, sel: #selector(_clickMy), title: "  我的", tintColor: .black)
        view.backgroundColor = SC_ThemeBackgroundViewColor
        headView.backgroundColor = SC_ThemeBackgroundViewColor
        navigationController?.navigationBar.barTintColor = SC_ThemeMainColor
        
        reftreshData()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    func _clickMy(){
        let vc = MyCardCouponContainerViewController()
        navigationController?.pushViewController(vc, animated: true)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataList.count == 0{
            tableView.mj_header.beginRefreshing()
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
                    self?.tableView.mj_footer.endRefreshing()
                })
                
            })
        }
        tableView.mj_header = MJRefreshNormalHeader {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                print("下拉刷新 --- 1")
                self?.page = 1
                self?._requstData(false, { [weak self] in
                    self?.tableView.mj_header.endRefreshing()
                });
            })
        }
        
    }
    
    fileprivate func _requstData(_ isLoad:Bool  , _ complete: @escaping () -> ()){
//        SCNetwork.shareInstance().v1_post(withUrl: CouponsVendorList_URL, params: _requstPrameter(isLoad), showLoading: false) { (baseModel, error) in
//            complete()
//        }
        
        SCNetwork.shareInstance().hh_Get(withUrl: CouponsVendorList_URL, parameters: _requstPrameter(isLoad), showLoading: false) { (baseModel, error) in
            if error != nil{
                complete()
                return
            }
            
            if let data = baseModel?.data as? Dictionary<String,Any>{
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
                self.noDataTipShow(self.tableView, content: "暂无数据", image: UIImage.loadImage("sc_com_icon_blankPage"), backgroundColor: SC_ThemeBackgroundViewColor)
                self.tableView.isScrollEnabled = false
            }else{
                self.tableView.isScrollEnabled = true
                self.noDataTipDismiss()
            }
            
            complete()
        }
        
    }
    
    
    fileprivate func _requstPrameter(_ isLoad:Bool) -> Dictionary<String, Any> {
        let pageStr = isLoad ? page+1:page
        return  ["roomid":SCCacheTool.shareInstance().chatRoomId,"pageSize":10,"pageNo":pageStr]
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
        let mcDate:MCDate = MCDate.init(interval: entity.deadline!)
        let dateStr = mcDate.formattedDate(withFormat: "YYYY-MM-dd")
        cell.deadlineLb.text = "有效期至:\(dateStr!)"
        cell.priceLb.text = "￥\(entity.price!)"
        
        
        let section:Int = indexPath.section
        if section % 2 == 0 {
            cell.bgIcon.image =  UIImage.init(name: "sc_com_icon_CardPackage_1")
            cell.nameLb.textColor = SC_EmphasisColor
            cell.nikeNameLb.textColor = SC_EmphasisColor
            cell.deadlineLb.textColor = SC_EmphasisColor
            cell.priceLb.textColor = SC_EmphasisColor
            cell.statusLb.textColor = .white
        }else{
            cell.bgIcon.image =  UIImage.init(name: "sc_com_icon_CardPackage")
            cell.nameLb.textColor = .white
            cell.nikeNameLb.textColor = .white
            cell.deadlineLb.textColor = .white
            cell.priceLb.textColor = .white
            cell.statusLb.textColor = SC_ThemeMainColor
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.backgroundColor = SC_ThemeBackgroundViewColor
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = SC_ThemeBackgroundViewColor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsVC = MyCardReceiveDetailsViewController()
        pushPage(detailsVC, animated: true)
        
        let entity = dataList[indexPath.section]
        SCNetwork.shareInstance().hh_Get(withUrl: CouponsVendorDetails_URL, parameters: ["couponsId":Int(entity.couponsId!)], showLoading: true) { (baseModel, error) in
            
        }
        
    }
    
}
