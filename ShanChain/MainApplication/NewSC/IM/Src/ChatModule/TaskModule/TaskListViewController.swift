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
    case myPublish //帮过我的
    case myReceive //我帮过的
    case myOver//已结束
}


private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)
private let H_TaskListCellID = "TaskListCell"
private let H_TaskListPersonalCellID = "TaskListPersonalCell"


class TaskListViewController: SCBaseVC,LTTableViewProtocal {
    
    
    public required init(type:TaskListType){
        self.type = type
        if self.type == TaskListType.all {
            
            self.titles = ["0":NSLocalizedString("sc_Alltask", comment: "字符串"),"1":NSLocalizedString("sc_Availabletasks", comment: "字符串")]
            self.statusCode = StatusCode.squareAll
        }else{
            self.titles = ["2":NSLocalizedString("sc_Alltask", comment: "字符串"),"3":NSLocalizedString("sc_MyPost", comment: "字符串"),"4":NSLocalizedString("sc_Myaccept", comment: "字符串"),"5":NSLocalizedString("sc_Ended", comment: "字符串")]
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
    let chatRoomId:String? = SCCacheTool.shareInstance().chatRoomId
    let titles:Dictionary<String,String>
    var statusCode:StatusCode = StatusCode.squareAll
    
    func _getEntitys() -> [ShowSelectEntity] {
        var mAry:[ShowSelectEntity] = []
        for (key,value) in self.titles {
            mAry.append(ShowSelectEntity.newInitialization(withValue: value, key:key))
        }
        return mAry
    }
    
    var selectEntitys:[ShowSelectEntity] = []
    fileprivate lazy var tableView: UITableView = {
        let H: CGFloat = glt_iphoneX ? (self.view.bounds.height - 64 - 24 - 34) : self.view.bounds.height  - 64
        let tableView = self.tableViewConfig(CGRect(x: 10, y: 30, width: self.view.bounds.width - 20, height: H), self, self, nil)
        tableView.register(UINib.init(nibName: H_TaskListCellID, bundle: nil), forCellReuseIdentifier: H_TaskListCellID)
        tableView.register(UINib.init(nibName: H_TaskListPersonalCellID, bundle: nil), forCellReuseIdentifier: H_TaskListPersonalCellID)
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
        btn.setTitle(NSLocalizedString("sc_Alltask", comment: "字符串"), for: .normal)
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
        selectEntitys = _getEntitys()
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
        tableView.mj_header.beginRefreshing()
        NotificationCenter.default.addObserver(self, selector: #selector(_notificationUpdateData), name: NSNotification.Name(rawValue: kPublishTaskSuccess), object: nil)
    }
    
    func _notificationUpdateData(){
        tableView.mj_header.beginRefreshing()
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
    
    @objc fileprivate func _requstData(_ isLoad:Bool  , _ complete: @escaping () -> ()) {
        SCNetwork.shareInstance().v1_post(withUrl: _getUrl(), params: _requstPrameter(isLoad), showLoading: false) { (baseModel, error) in
            
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
            
            complete()
        }
    }
    
   fileprivate func _requstPrameter(_ isLoad:Bool) -> Dictionary<String, Any> {
        let pageStr = isLoad ? "\(page+1)":"\(page)"
    if statusCode == .squareAll || statusCode == .squareUnaccalimed{
        return ["characterId":characterId,"page":pageStr,"size":size,"roomId":chatRoomId ?? ""]
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
    
    public func cellWithPersonalTableView<T:TaskListPersonalCell>(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> T {
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
        if dataList.count > 0 {
            return  dataList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let content = dataList[indexPath.section];
        if self.type == TaskListType.all {
            let cell = cellWithTableView(tableView, cellForRowAt: indexPath)
            cell.delegate = self
            cell.listModel = content
            return cell
        }
        let cell = cellWithPersonalTableView(tableView, cellForRowAt: indexPath)
        cell.delegate = self
        cell.listModel = content
        
        let lastCell = tableView.visibleCells.first as? TaskListPersonalCell
        if let lastCell = lastCell {
            if (lastCell.revealedCardIsFlipped){
                lastCell.flipRevealedCardBack()
            }
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        let content = dataList[indexPath.section];
        if self.type == TaskListType.all {
       //  let  cell = (tableView.cellForRow(at: indexPath) as?  TaskListCell)!
        }else{
          let  cell = (tableView.cellForRow(at: indexPath) as?  TaskListPersonalCell)!
            if (cell.revealedCardIsFlipped){
                cell.flipRevealedCardBack()
            }else{
                let backView = TaskListBackView(listModel: content, frame: cell.frame)
                backView.tag = indexPath.section;
                backView.delegate = self
                cell.flipRevealedCard(toView: backView) {}
            }
            
        }
  
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 10.0
    }

}

extension TaskListViewController:TaskListCellProtocol{
   
    // 点击头像
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
    
    func urgeComplete(listModel: TaskListModel, view: TaskListBackView) {
        requestListCellDelegateWithUrl(url: TASK_URGE_URL, listModel: listModel, view: view)
    }
    
    
    func publishConfirmComplete(listModel: TaskListModel, view: TaskListBackView) {
       requestListCellDelegateWithUrl(url: TASK_CONRIRM_COMPLETE_URL, listModel: listModel, view: view)
    }
    
    func receiveCompleted(listModel: TaskListModel, view: TaskListBackView) {
       requestListCellDelegateWithUrl(url: RECEIVE_ACCOMPLISH_URL, listModel: listModel, view: view)
    }
    
    func receiveCancel(listModel: TaskListModel, view: TaskListBackView) {
       requestListCellDelegateWithUrl(url: TASK_CANCEL_URL, listModel: listModel, view: view)
    }
    
    
    func callBack(listModel: TaskListModel) {
        if(!listModel.isReceived){
            let detailsVC = TaskDetailsViewController(taskID: listModel.taskId!, content: listModel.intro!, reward: listModel.price!, time: listModel.expiryTime!)
            navigationController?.pushViewController(detailsVC, animated: true)
        }
       
    }
    
    // 发布方点击未完成
    func publishConfirmUndone(listModel: TaskListModel, view: TaskListBackView) {
        requestListCellDelegateWithUrl(url: CONFIRM_UNDONE_URL, listModel: listModel, view: view)
    }
    
    fileprivate func requestListCellDelegateWithUrl(url:String,listModel:TaskListModel,view:TaskListBackView){
        SCNetwork.shareInstance().v1_post(withUrl: url, params: ["characterId":characterId,"taskId":listModel.taskId!,"userId":SCCacheTool.shareInstance().getCurrentUser()], showLoading: true) { (baseModel, error) in
            if((error) != nil){
                HHTool.showError(error?.localizedDescription)
                return
            }
            self._requstData(false, {
                view.listModel = self.dataList[view.tag]
                
                for (_,cell) in self.tableView.visibleCells.enumerated(){
                    if let cell = cell as? TaskListPersonalCell{
                        cell.flipRevealedCardBack()
                    }
                }
                self.tableView.scrollToNearestSelectedRow(at: .top, animated: true)
            })
            
        }
    }
    
}
