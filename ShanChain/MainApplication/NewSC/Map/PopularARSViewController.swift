//
//  PopularARSViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/5/28.
//  Copyright © 2019 ShanChain. All rights reserved.
//

import UIKit

class PopularARSViewController: SCBaseVC {

    private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)
    
    fileprivate  let  k_cellID  = "HotCommunityCell"
    
    var dataList:[HotCommunityModel] = []
    /// ARS 可以执行点击确认操作的状态
    var isClickSure = true
    var viewHeight: CGFloat = 0
    
    var table: UITableView!
    
    var sourceTimer :DispatchSourceTimer!
    var timeCount = 60
    
    lazy var sureAlertViewController: UIAlertController = {
        let alert = UIAlertController(title: "ARS -> 确认进入下一层! 倒计时: 开始", message: "", preferredStyle: UIAlertController.Style.alert)
        let sureAction = UIAlertAction(title: "确认", style: .default) { (action) in
            if self.isClickSure {
                self.confirm()
            }else {
                HHTool.showTip("进入下一层的时间已经结束，多谢参与！！", duration: 1)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        alert.addAction(sureAction)
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurationUI()
        requestData()
    

    }
    
    func configurationUI() {
        
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        let Y: CGFloat = statusBarH + 44
        let H: CGFloat = glt_iphoneX ? (self.view.bounds.height - Y - 34) : self.view.bounds.height - Y
        viewHeight = H
        let tableView = UITableView(frame: CGRect(x: 15, y: 0, width: view.width - 30, height: H), style: .plain)
        tableView.backgroundColor = SC_ThemeBackgroundViewColor
        tableView.rowHeight = 250
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        let headview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.width - 30, height: 15))
        headview.backgroundColor = SC_ThemeBackgroundViewColor
        tableView.tableHeaderView = headview
        view.addSubview(tableView)
        tableView.register(UINib.init(nibName: k_cellID, bundle: nil), forCellReuseIdentifier: k_cellID)
        table = tableView
        glt_scrollView = tableView
        
        
        // 支付成功
        NotificationCenter.default.addObserver(self, selector: #selector(ARSPayAction), name: .ARSPaySuccess, object: nil)
        // 确认进入下一层
        NotificationCenter.default.addObserver(self, selector: #selector(joinNext), name: .SysMessage, object: nil)
        // 进入下一层时间结束
        NotificationCenter.default.addObserver(self, selector: #selector(confirmEnd), name: .confirmNum, object: nil)
    }
    
    
    func requestData() {
        
        SCNetwork.shareInstance()?.hh_Get(withUrl: "/v1/2.0/arsRoomList", parameters: ["userId":SCCacheTool.shareInstance()?.getCurrentUser(),"charaterId":SCCacheTool.shareInstance()?.getCurrentCharacterId()], showLoading: true, call: { (model, err) in
            
            if let tmpModel = model {
                
                if let datas:[HotCommunityModel] = [HotCommunityModel].deserialize(from: tmpModel.data as? [Any]) as? [HotCommunityModel]{

                    self.dataList = datas
                    self.table.reloadData()
                }
              
            }
        })
    }

}

extension PopularARSViewController: UITableViewDelegate, UITableViewDataSource, HotCommunityCellProtocol {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataList.count > 0 {
            return dataList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: k_cellID, for: indexPath) as! HotCommunityCell
        cell.joinBtn.tag = indexPath.section
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HotCommunityCell else {
            return
        }
        cell.selectionStyle = .none
        let hotModel = self.dataList[indexPath.section]
        
        cell.coverIcon._sd_setImage(withURLString: hotModel.background)
        cell.coverIcon.preventImageViewExtrudeDeformation()
        cell.mapIcon._sd_setImage(withURLString: hotModel.thumbnails)
        cell.peopleNumberLb.text = hotModel.userNum
        cell.nameLb.text = hotModel.roomName
        cell.cellMaskView.isHidden = hotModel.litUp ?? false
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: view.width - 30, height: 15))
    }
    // MARK: - HotCommunityCellProtocol
    
    func joinChatRoomFor(index: Int) {
        
//        SCWebSocket.manager.sendWebSocket(["type":"SysMessage","userId":SCCacheTool.shareInstance()?.getCurrentUser() as Any])
        
        let joinModel = self.dataList[index]

        if joinModel.pay ?? false {
            enterFirstFloor(joinModel)
        }else {
            // 去支付100SEAT TODO

            let paySEATAlertViewController = UIAlertController(title: "支付100个 SEAT 参与 ARS 活动", message: "", preferredStyle: UIAlertController.Style.alert)
            let sureAction = UIAlertAction(title: "确认", style: .default) { (action) in

                let vv = UploadPhotePasswordView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.viewHeight - 44))
                vv.imageViewTag = 215
                vv.vc = self
                vv.closure = { (b,authcode) in
                    SCWebSocket.manager.sendWebSocket(["type":"ARSPaySuccess","userId":SCCacheTool.shareInstance()?.getCurrentUser() as Any])
                }
                self.view.addSubview(vv)
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in

            })
            paySEATAlertViewController.addAction(sureAction)
            paySEATAlertViewController.addAction(cancelAction)

            self.present(paySEATAlertViewController, animated: true, completion: nil)


        }
    }
}

extension PopularARSViewController {
    
    // MARK: - ARS
    /// ARS-进入首层接口 -> 这里 已经支付100SEAT成功，进入聊天室
    func enterFirstFloor(_ model: HotCommunityModel) {
        guard let userid = SCCacheTool.shareInstance()?.getCurrentUser(),let subuserid = SCCacheTool.shareInstance()?.getCurrentCharacterId(),let token = SCCacheTool.shareInstance()?.getUserToken() else {
            
            return
        }
        let tmp = String(format: "/v1/2.0/ars/enterfirstfloor?userId=%@&subuserId=%@&token=%@",userid,subuserid,token)
        SCNetwork.shareInstance()?.hh_post(withUrl: tmp, params: [:] as [AnyHashable : Any], showLoading: false, call: { (baseModel, error) in
            print("ARS-进入首层接口",baseModel?.code as Any,baseModel?.data as Any,baseModel?.message as Any)
            if let code = baseModel?.code,code == "000000" {
                // 进入聊天室
                self.join(model)
                self.requestData()
            }
        })
        
    }
    /// ARS-确认进入下一层接口
    func confirm() {
        guard let userid = SCCacheTool.shareInstance()?.getCurrentUser(),let subuserid = SCCacheTool.shareInstance()?.getCurrentCharacterId(),let token = SCCacheTool.shareInstance()?.getUserToken() else {
            
            return
        }
        let tmp = String(format: "/v1/2.0/ars/confirm?userId=%@&subuserId=%@&token=%@",userid,subuserid,token)
        SCNetwork.shareInstance()?.hh_post(withUrl: tmp, params: [:] as [AnyHashable : Any], showLoading: false, call: { (baseModel, error) in
            print("ARS-确认进入下一层接口",baseModel?.code as Any,baseModel?.data as Any,baseModel?.message as Any)
            if let code = baseModel?.code,code == "000000" {
                self.requestData()
            }
        })
    }
    /// 进入聊天室
    func join(_ model: HotCommunityModel) {
        SCCacheChatRecord.shareInstance().createTable(withRoomId: model.roomId!)
        
        let chatRecords = SCCacheChatRecord.shareInstance().selectData(withRoomId: model.roomId!) as! [String]
        
        JGUserLoginService.jg_enterchatRoom(roomId: model.roomId!) { (conversation , error) in
            if error == nil && conversation != nil{
                
                let chatRoomVC:HHChatRoomViewController = HHChatRoomViewController.init(conversation: conversation!, isJoinChat: false, navTitle: model.roomName!)
                chatRoomVC.takeImage = UIImage.init(fromURLString: model.thumbnails)
                chatRoomVC.shareTakeUrl = model.thumbnails
                
                chatRoomVC.chatRecords = chatRecords
                self.pushPage(chatRoomVC, animated: true)
                
                
            }
        }
    }
    
    // MARK: 倒计时
    func joinNext2CountDown(interval:TimeInterval) -> Void {
        
        sourceTimer = DispatchSource.makeTimerSource()
        sourceTimer.schedule(deadline:.now()+interval, repeating: DispatchTimeInterval.milliseconds(1000), leeway: DispatchTimeInterval.milliseconds(0))
        sourceTimer.setEventHandler {
            if self.timeCount != 0 {
                self.timeCount -= 1
                DispatchQueue.main.async {
                    self.sureAlertViewController.title = "ARS -> 确认进入下一层! 倒计时: \(Int(self.timeCount/60))分\(Int(Float(self.timeCount).truncatingRemainder(dividingBy: 60)))秒"
                }
            }else if self.timeCount == 0 {
                self.sourceTimer.cancel()
                DispatchQueue.main.async {
                    print("结束")
                    self.sureAlertViewController.title = "ARS -> 确认进入下一层! 倒计时: 结束"
                    self.sureAlertViewController.dismiss(animated: true, completion: {
                        
                    })
                }
            }
        }
        // 启动定时器
        sourceTimer.resume()
        
    }
    
    
    // MARK: - ARS -> websocket 事件回调
    
    // 支付成功操作事件
    @objc func ARSPayAction(notification: Notification) {
        print("支付成功了,现在可以进入ARS第一层了",notification.userInfo as Any)
        
        if let info = notification.userInfo, let userid = info["userId"] as? String {
            if userid == SCCacheTool.shareInstance()?.getCurrentUser() {
                enterFirstFloor(self.dataList[0])
                
            }
        }
        
    }
    // 确认进入下一层操作事件
    @objc func joinNext(notification: Notification) {

        print("ARS 确认进入下一层",notification.userInfo as Any)
        
        if let info = notification.userInfo, let list = info["list"] as? Array<Int>, let endTime = info["endTime"] as? Double {
            
            for uId in list {
                let userId = String(uId)
                if userId == SCCacheTool.shareInstance()?.getCurrentUser() {
                    //获取当前的时间戳
                    let currentTime = Date().timeIntervalSince1970
                    //时间戳为毫秒级要 ／ 1000
                    let timeSta:TimeInterval = TimeInterval(endTime / 1000)
                    //时间差
                    let reduceTime : TimeInterval = ceil(timeSta - currentTime)
                    self.timeCount = Int(reduceTime)
                    joinNext2CountDown(interval: 1)

                    self.present(sureAlertViewController, animated: true, completion: nil)
                    
                }
            }
        }
    }
    // 进入下一层时间结束操作事件
    @objc func confirmEnd(notification: Notification) {
        if let info = notification.userInfo, let num = info["num"] as? Int {
            if num != 0 {
                if let list = info["confirmList"] as? Array<Int>, let uId = SCCacheTool.shareInstance()?.getCurrentUser() {
                    
                    self.isClickSure = list.contains(Int(uId)!)
                }
            }else {
                self.isClickSure = false
            }
        }
    }
    
    
}
