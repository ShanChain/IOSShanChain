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
    
    @IBOutlet var RsView: UIView!
    
    @IBOutlet weak var Rs_titleLb: UILabel!
    
    @IBOutlet weak var Rs_contactBtn: UIButton!
    
    
    @IBOutlet weak var Rs_desLb: UILabel!
    var page:Int = 0
    let size:String = "10"
    fileprivate var dataList:[TaskListModel] = []
    fileprivate let characterId:String = SCCacheTool.shareInstance().getCurrentCharacterId()
    fileprivate let chatRoomId:String? = SCCacheTool.shareInstance().chatRoomId
    fileprivate var recieveSuccessModel:TaskRecieveSuccessModel?
    
    
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
        title = NSLocalizedString("sc_RewardTask", comment: "字符串")
        _snpLayout()
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib.init(nibName: H_cell, bundle: nil), forCellReuseIdentifier: H_cell)
        tableView.backgroundColor = SC_ThemeBackgroundViewColor
        self.addRightBarButtonItem(withTarget: self, sel: #selector(_myHelp), title: NSLocalizedString("sc_Voucher_My", comment: "字符串"), tintColor: .black)
        view.backgroundColor = SC_ThemeBackgroundViewColor
        headerView.backgroundColor = SC_ThemeBackgroundViewColor
        navigationController?.navigationBar.barTintColor = .white
        reftreshData()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        helpBtn.setTitle(NSLocalizedString("sc_PostTask", comment: "字符串"), for: .normal)
        //        self.showNavigationBarWhiteColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.mj_header.beginRefreshing()
    }
    
    
    // 寻求帮助
    @IBAction func seekHelpAction(_ sender: UIButton) {
        
        // 发布任务
        UIView .animate(withDuration: 0.2) {
            
            let pubTaskView:PublishTaskView? =
                PublishTaskView(taskModel: nil, frame: CGRect(x: 0, y:0, width: Int(SCREEN_WIDTH), height: Int(SCREEN_HEIGHT)))
            pubTaskView?.cornerRadius = 0.01
            pubTaskView?.borderColor = .clear
            pubTaskView?.tag = 6666
            // 点击发布任务回调
            pubTaskView?.pbCallClosure = { [weak self] (dataString,reward,time,timestamp,isPut)  in
                pubTaskView?.dismiss()
                if isPut == false{
                    return
                }
                let characterId:String = SCCacheTool.shareInstance().getCurrentCharacterId()
                
                let isPwd = SCCacheTool.shareInstance().characterModel.characterInfo.isBindPwd == true && SCCacheTool.shareInstance().getAuthCode().isEmpty == false
                let authCode:String = isPwd  == true ? SCCacheTool.shareInstance().getAuthCode():""
                let params:Dictionary = ["bounty":reward,"currency":"rmb","dataString":dataString,"roomId":self!.chatRoomId ?? "","time":timestamp,"characterId":characterId,"authCode":authCode] as [String : Any]
                // 添加任务
                HHTool.showChrysanthemum()
                SCNetwork.shareInstance().v1_post(withUrl: TASK_ADD_URL, params: params, showLoading: true, call: { (baseModel, error) in
                    HHTool.immediatelyDismiss()
                    if((error) != nil){
                        HHTool .showError(NSLocalizedString("sc_helpFailed", comment: "字符串"))
                        return
                    }
                    self?.tableView.mj_header.beginRefreshing()
                    HHTool .showSucess(NSLocalizedString("sc_helpAccomplished", comment: "字符串"))
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPublishTaskSuccess), object: nil)
                })
            }
            self.view.addSubview(pubTaskView!)
        }
    }
    
    func _myHelp(){
        let vc = MyHelpContainerViewController()
        vc.currentChatRoomID = chatRoomId
        vc._scrollToIndex = .I_helped
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func removeFromRecieveSuccessView(_ sender: Any) {
        self.RsView.removeFromSuperview()
    }
    // 联系赏主
    @IBAction func contactHeAction(_ sender: UIButton) {
        self.RsView.removeFromSuperview()
        let HxUserName = recieveSuccessModel?.HxUserName ?? ""
        JMSGConversation.createSingleConversation(withUsername: HxUserName, completionHandler: { (result, error) in
            if error == nil {
                ChatPublicService.jg_addFriendFeFocus(funsJmUserName: HxUserName)
                let conv = result as! JMSGConversation
                let vc = JCChatViewController(conversation: conv)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateConversation), object: nil, userInfo: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
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
    
    // 领取任务
    fileprivate func _receiveTaskPrameter(taskId:String) -> Dictionary<String, Any> {
        return ["characterId":characterId,"roomId":chatRoomId ?? "","taskId":taskId]
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
        cell.selectionStyle = .none
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
        
        SCNetwork.shareInstance().v1_post(withUrl: TASK_RECEIVE_URL, params: _receiveTaskPrameter(taskId: listModel.taskId!), showLoading: true) { (baseModel, error) in
            if (error != nil){
                return
            }
            self.tableView.mj_header.beginRefreshing()
            self.RsView.frame = self.view.frame
            self.RsView.alphaComponentMake()
            self.view.addSubview(self.RsView)
            let dict = baseModel?.data as! Dictionary<String,Any>
            if let model = TaskRecieveSuccessModel.deserialize(from: dict){
                self.recieveSuccessModel = model
            }
        }
    }
}

