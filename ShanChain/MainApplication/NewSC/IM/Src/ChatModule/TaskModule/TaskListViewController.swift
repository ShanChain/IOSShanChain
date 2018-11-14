//
//  TaskListViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/2.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit
import LTScrollView

enum StatusCode:Int{
    case squareAll = 0
    case squareUnaccalimed // 广场未领取
    case myAll // 我全部任务
    case myPublish //我发布的
    case myReceive //我领取的
    case myOver//已结束
}


private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)
private let H_TaskListCellID = "TaskListCell"

class TaskListViewController: SCBaseVC,LTTableViewProtocal {
    
    
    public required init(type:TaskListType){
        self.type = type
        if self.type == TaskListType.all {
            self.titles = ["0":"全部任务","1":"未领取任务"]
            self.statusCode = StatusCode.squareAll
        }else{
            self.titles = ["2":"全部任务","3":"我发布的","4":"我领取的","5":"已结束的"]
            self.statusCode = StatusCode.myAll
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var page:Int = 0
    let size:String = "10"
    fileprivate var type:TaskListType?
    fileprivate var dataList:[TaskListModel] = []
    let characterId:String = SCCacheTool.shareInstance().getCurrentCharacterId()
    let chatRoomId:String = SCCacheTool.shareInstance().chatRoomId
    let titles:Dictionary<String,String>
    var statusCode:StatusCode = StatusCode.squareAll
    
    
    var selectEntitys:[ShowSelectEntity]{
        var mAry:[ShowSelectEntity] = []
        for (key,value) in self.titles {
            mAry.append(ShowSelectEntity.newInitialization(withValue: value, key:key))
        }
        return mAry
    }
    
    fileprivate lazy var tableView: UITableView = {
        let H: CGFloat = glt_iphoneX ? (self.view.bounds.height - 64 - 24 - 34) : self.view.bounds.height  - 64
        let tableView = self.tableViewConfig(CGRect(x: 10, y: 30, width: self.view.bounds.width - 20, height: H), self, self, nil)
        tableView.register(UINib.init(nibName: H_TaskListCellID, bundle: nil), forCellReuseIdentifier: H_TaskListCellID)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    fileprivate lazy var topView:UIView = {
        let headerView:UIView = UIView(frame: CGRect(x: 10, y: 0, width: self.view.bounds.width - 20, height: 30))
        headerView.backgroundColor = self.view.backgroundColor
        let btn:UIButton = UIButton.init(type: .custom)
        if (self.type == TaskListType.all){
           btn.setTitle("全部任务", for: .normal)
        }else{
            btn.setTitle("我发布的", for: .normal)
        }
        
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = Font(15)
        btn.addTarget(self, action: #selector(clickSelectStatusAction(_:)), for:.touchUpInside)
        btn.titleLabel?.textAlignment = .left
        btn.backgroundColor = .white
        headerView.addSubview(btn)
        btn.snp.makeConstraints { (mark) in
            mark.centerY.equalTo(headerView)
            mark.left.right.equalTo(headerView)
            mark.height.equalTo(30)
        }
        
        return headerView
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SC_ThemeBackgroundViewColor
        tableView.backgroundColor = SC_ThemeBackgroundViewColor
        view.addSubview(topView)
        view.addSubview(tableView)
        glt_scrollView = tableView
        reftreshData()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        _requstData(false) {}
        
       
    }
   
    func _getUrl() -> String {
        switch self.statusCode {
        case .squareAll:
            return ROOMTASK_LIST_URL
        case .squareUnaccalimed:
            return NACCALIMED_LIST_URL
        case .myAll:
            return INDIVIDUAL_LIST_URL
        case .myPublish:
            return PUBLISHTASK_LIST_URL
        case .myReceive:
            return RECEIVETASK_LIST_URL
        case .myOver:
            return ENDTASK_LIST_URL
        }
       
    }
    
    fileprivate func _requstData(_ isLoad:Bool  , _ complete: @escaping () -> ()) {
        SCNetwork.shareInstance().v1_post(withUrl: _getUrl(), params: _requstPrameter(isLoad), showLoading: true) { (baseModel, error) in
            complete()
            if (error != nil){
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
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                
            }
            
       
        }
    }
    
   fileprivate func _requstPrameter(_ isLoad:Bool) -> Dictionary<String, Any> {
        let pageStr = isLoad ? "\(page+1)":"\(page)"
    if statusCode == .squareAll || statusCode == .squareUnaccalimed{
        return ["characterId":characterId,"page":pageStr,"size":size,"roomId":chatRoomId]
    }
    return  ["characterId":characterId,"page":pageStr,"size":size]
}
    
    
}


extension TaskListViewController {
    
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

    private func configIdentifier(_ identifier: inout String) -> String {
        var index = identifier.index(of: ".")
        guard index != nil else { return identifier }
        index = identifier.index(index!, offsetBy: 1)
        identifier = String(identifier[index! ..< identifier.endIndex])
        return identifier
    }
    
    public func registerCell(_ tableView: UITableView, _ cellCls: AnyClass) {
        var identifier = NSStringFromClass(cellCls)
        identifier = configIdentifier(&identifier)
        tableView.register(cellCls, forCellReuseIdentifier: identifier)
    }
    
    public func cellWithTableView<T: TaskListCell>(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> T {
        var identifier = NSStringFromClass(T.self)
        identifier = configIdentifier(&identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        return cell as! T
    }
    
    public func tableViewConfig(_ delegate: UITableViewDelegate, _ dataSource: UITableViewDataSource, _ style: UITableViewStyle?) -> UITableView  {
        let tableView = UITableView(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: style ?? .plain)
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        return tableView
    }
    
    public func tableViewConfig(_ frame: CGRect ,_ delegate: UITableViewDelegate, _ dataSource: UITableViewDataSource, _ style: UITableViewStyle?) -> UITableView  {
        let tableView = UITableView(frame: frame, style: style ?? .grouped)
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        return tableView
    }
    
    func clickSelectStatusAction(_ sender:UIButton){
        let selectView:ShowSelectTableView = ShowSelectTableView(frame: CGRect(x: 0, y: 0, width: Int(view.width), height: Int(view.height)), modelsArray: selectEntitys)
        selectView.selectEntityBlock = { (entity) in
            if entity != nil {
                sender.setTitle(entity!.value, for: .normal)
                self.page = 0
                self.statusCode = StatusCode(rawValue:Int((entity?.key)!)!)!
                self._requstData(false, {})
            }
            
        }
        view.addSubview(selectView)
    }
    
}


extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellWithTableView(tableView, cellForRowAt: indexPath)
        let content = dataList[indexPath.section];
        cell.rewardLabel.text = "\(content.bounty ?? "") SEAT"
        cell.contentLabel.text = content.intro
        cell.icon._sd_setImage(withURLString: content.headImg, placeholderImage: SC_defaultImage)
        cell.issueLabel.text = "\(content.name ?? "")发布的:"
        cell.issueDateLabel.text = "\(NSDate.chatingTime(content.expiryTime) ?? "") 前"
        cell.locactionLabel.text = "来自:\(content.roomName ?? "")"
        cell.cornerRadius = 10.0
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as? TaskListCell
        if (cell?.revealedCardIsFlipped)!{
            cell?.flipRevealedCardBack()
        }else{
            let backView = TaskListBackView(frame: (cell?.frame)!)
            cell?.flipRevealedCard(toView: backView)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 10.0
    }
    
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100.0
//    }
}
