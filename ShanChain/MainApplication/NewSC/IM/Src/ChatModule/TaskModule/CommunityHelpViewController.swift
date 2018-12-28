//
//  CommunityHelpViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/27.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

private let H_cell = "HelpCenterCell"

class CommunityHelpViewController: SCBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet var headerView: UIView!
    
    
    @IBOutlet weak var helpBtn: UIButton!
    
    
    var page:Int = 0
    let size:String = "10"
    fileprivate var dataList:[TaskListModel] = []
    fileprivate let characterId:String = SCCacheTool.shareInstance().getCurrentCharacterId()
    fileprivate let chatRoomId:String? = SCCacheTool.shareInstance().chatRoomId
    
    func _snpLayout(){
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (mk) in
            mk.left.right.equalTo(0)
            mk.top.equalTo(self.topLayoutGuide.snp.bottom)
            mk.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { (mark) in
            mark.top.equalTo(headerView.snp.bottom)
            mark.left.equalTo(15)
            mark.right.equalTo(-15)
            mark.bottom.equalTo(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "社区帮"
        _snpLayout()
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib.init(nibName: H_cell, bundle: nil), forCellReuseIdentifier: H_cell)
        tableView.backgroundColor = SC_ThemeBackgroundViewColor
        self.addRightBarButtonItem(withTarget: self, sel: #selector(_myHelp), title: "  我的", tintColor: .black)
        view.backgroundColor = SC_ThemeBackgroundViewColor
        headerView.backgroundColor = SC_ThemeBackgroundViewColor
        navigationController?.navigationBar.barTintColor = .white
        reftreshData()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        self.showNavigationBarWhiteColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.mj_header.beginRefreshing()
    }
    
    func _myHelp(){
        
    }
    

}

extension CommunityHelpViewController{
    
    fileprivate func reftreshData()  {
        tableView.mj_footer = MJRefreshBackNormalFooter {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                print("上拉加载更多数据")
                self?._requstData(true, { [weak self] in
                    self?.tableView.mj_footer.endRefreshing()
                })
                
            })
        }
        tableView.mj_header = MJRefreshNormalHeader {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                print("下拉刷新 --- 1")
                self?.page = 0
                self?._requstData(false, { [weak self] in
                    self?.tableView.mj_header.endRefreshing()
                });
            })
        }
        
    }

    
    
     fileprivate func _requstData(_ isLoad:Bool  , _ complete: @escaping () -> ()) {
        SCNetwork.shareInstance().v1_post(withUrl: ROOMTASK_LIST_URL, params: _requstPrameter(isLoad), showLoading: false) { (baseModel, error) in
            
            if error != nil{
                return
            }
            let data = baseModel?.data as! Dictionary<String,Any>
            let arr = data["content"] as! NSArray
            if let datas:[TaskListModel] = [TaskListModel].deserialize(from: arr) as? [TaskListModel]{
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
            
            if self.dataList.count == 0 {
                self.noDataTipShow(self.tableView, content:NSLocalizedString("sc_taskEmpty", comment: "字符串"), image: UIImage.loadImage("sc_com_icon_blankPage"), backgroundColor: SC_ThemeBackgroundViewColor)
                self.tableView.isScrollEnabled = false
            }else{
                self.tableView.isScrollEnabled = true
                self.noDataTipDismiss()
            }
            
            self.tableView.reloadData()
            complete()
        }
    }
    
    fileprivate func _requstPrameter(_ isLoad:Bool) -> Dictionary<String, Any> {
        let pageStr = isLoad ? "\(page+1)":"\(page)"
       return ["characterId":characterId,"page":pageStr,"size":size,"roomId":chatRoomId ?? ""]
    }
    
}


extension CommunityHelpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataList.count > 0 {
            return  dataList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let content = dataList[indexPath.section];
        let cell = tableView.dequeueReusableCell(withIdentifier: H_cell, for: indexPath) as! HelpCenterCell
        cell.delegate = self
        cell.listModel = content
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}

extension CommunityHelpViewController: HelpCenterCellProtocol{
    
    func _clickAvatar(listModel: TaskListModel) {
        if listModel.isBelongMy == false{
            JMSGUser.userInfoArray(withUsernameArray: [listModel.hxUserName]) { (result, error) in
                if let result = result{
                    let user:JMSGUser = (result as! Array )[0]
                    let vc = JCUserInfoViewController()
                    vc.user = user
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func _helpHereWith(listModel: TaskListModel) {
        
    }
}

