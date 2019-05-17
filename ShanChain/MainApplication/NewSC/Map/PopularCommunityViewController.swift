//
//  PopularCommunityViewController.swift
//  ShanChain
//  
//  Created by 千千世界 on 2018/12/18.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit


fileprivate  let  k_cellID  = "HotCommunityCell"

class PopularCommunityViewController: SCBaseVC {

    
    @IBOutlet weak var tableView: UITableView!
    
    var dataList:[HotCommunityModel] = []
    var page:Int = 0
    let size:String = "10"
    /// 添加元社区成功的状态
    var addChatRoomState: Bool = false

    lazy var searchBar: UISearchBar = {
        let item = UISearchBar()
        item.placeholder = "请输入元社区名称"
        item.delegate = self
        if #available(iOS 11.0, *) {
            item.searchBarStyle = .minimal
        }
        
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "与一半地球人共创社区"
//        tableView.rowHeight = 250
        tableView.estimatedRowHeight = 250
        tableView.backgroundColor = SC_ThemeBackgroundViewColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib.init(nibName: k_cellID, bundle: nil), forCellReuseIdentifier: k_cellID)
        let footview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: 15))
        footview.backgroundColor = SC_ThemeBackgroundViewColor
        tableView.tableFooterView = footview
        reftreshData()
        _requstData(false) {}
        self.addRightBarButtonItem(withTarget: self, sel: #selector(_earthAction), image: UIImage.loadDefaultImage("sc_EarthNew"), selectedImage: UIImage.loadDefaultImage("sc_EarthNew"))
        _updateAvatar()
//        let leftImageName = SCCacheTool.shareInstance().characterModel.characterInfo.headImg
//        self.addLeftBarButtonItem(withTarget: self, sel: #selector(_maskAnimationFromLeft), imageName: leftImageName, selectedImageName: leftImageName)
        NotificationCenter.default.addObserver(self, selector: #selector(_updateAvatar), name:  NSNotification.Name(rawValue: kUpdateAvatarSuccess), object: nil)
        // 抽屉
        self.cw_registerShowIntractive(withEdgeGesture: false) { (direction) in
            if direction == CWDrawerTransitionDirection.fromLeft{
                self._maskAnimationFromLeft()
            }
        }
        
        view.addSubview(self.searchBar)
        var seacrTop = 64
        if IS_IPHONE_X() {
            seacrTop = 88
        }
        self.searchBar.snp.makeConstraints { (make) in
            make.trailing.equalTo(view)
            make.leading.equalTo(view)
            make.top.equalTo(seacrTop)
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
        
//        NotificationCenter.default.addObserver(self, selector: #selector(test(notif:)), name: NSNotification.Name(rawValue:"sysMsg"), object: nil)
    }
//    func test(notif: Notification) {
//        print(notif.userInfo!)
//    }
    @objc func _earthAction(){
        let vc = BMKTestLocationViewController()
        vc.isAddChatRoom = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func _maskAnimationFromLeft(){
        let vc = LeftViewController()
        self.cw_showDrawerViewController(vc, animationType: CWDrawerAnimationType.mask, configuration: nil)
    }
    
    @objc func _updateAvatar(){
        let leftImageName = SCCacheTool.shareInstance().characterModel.characterInfo.headImg
        self.addLeftBarButtonItem(withTarget: self, sel: #selector(_maskAnimationFromLeft), imageName: leftImageName, selectedImageName: leftImageName)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if addChatRoomState {
            self.page = 0
            self.dataList = []
            self._requstData(false, {})
            self.tableView.scrollsToTop = true
            addChatRoomState = false
        }
    }
    
    fileprivate func reftreshData()  {
        tableView.mj_footer = MJRefreshBackNormalFooter {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                print("上拉加载更多数据")
                self?.page += 1
                self?._requstData(true, { [weak self] in
                    self?.tableView.mj_footer.endRefreshing()
                })
                
            })
        }
        
        
    }
    
    @objc fileprivate func _requstData(_ isLoad:Bool  , _ complete: @escaping () -> ()) {
        if (tableView.mj_footer == nil) {
            reftreshData()
        }
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        SCNetwork.shareInstance().hh_Get(withUrl: HotChatRoom_URL, parameters: ["page":page,"size":size,"version":currentVersion], showLoading: true) { (baseModel, error) in
            if error != nil{
                complete()
                return
            }
            if let tmpModel = baseModel {
                let data = tmpModel.data as? Dictionary<String, Any>
                
                let content = data!["content"] as? [Any]
                
                if let datas:[HotCommunityModel] = [HotCommunityModel].deserialize(from: content) as? [HotCommunityModel]{
                    if (datas.count > 0){
                        if(isLoad){
                            for item in datas{
                                self.dataList.append(item)
                            }
                        }else{
                            self.dataList = datas
                            self.noDataTipDismiss()
                        }
                        
                        self.tableView.reloadData()
//                        complete()
                    }else{
                        if isLoad == false{
                            self.dataList.removeAll()
                            self.noDataTipShow(self.tableView, content:NSLocalizedString("sc_taskEmpty", comment: "字符串"), image: UIImage.loadImage("sc_com_icon_blankPage"), backgroundColor: SC_ThemeBackgroundViewColor)
                        }
                        complete()
//                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    
                }
                complete()
//                let numberOfElements = data!["numberOfElements"] as! Int
                
                
//                if content?.count  == 0{
//                    self.noDataTipShow(self.tableView, content:NSLocalizedString("sc_Nodata", comment: "字符串"), image: UIImage.loadImage("sc_com_icon_blankPage"), backgroundColor: SC_ThemeBackgroundViewColor)
//                    self.dataList = []
//                    self.tableView.reloadData()
//                    return;
//                }
//                if let datas:[HotCommunityModel] = [HotCommunityModel].deserialize(from: content) as? [HotCommunityModel]{
//                    self.noDataTipDismiss()
//                    self.dataList = datas
//                    self.tableView.reloadData()
//                    self.tableView.scrollsToTop = true
//                }
            }
//            let data = baseModel?.data as! [Any]
//            if data.count  == 0{
//                 self.noDataTipShow(self.tableView, content:NSLocalizedString("sc_Nodata", comment: "字符串"), image: UIImage.loadImage("sc_com_icon_blankPage"), backgroundColor: SC_ThemeBackgroundViewColor)
//                self.dataList = []
//                self.tableView.reloadData()
//                return;
//            }
//            if let datas:[HotCommunityModel] = [HotCommunityModel].deserialize(from: data) as? [HotCommunityModel]{
//                self.dataList = datas
//                self.tableView.reloadData()
//            }
            
        }
        
    }
    
    @IBAction func bottomBtnAction(_ sender: UIButton) {
        switch sender.tag {
        case 21:
            let vc = AppointmentListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 22:
            let vc = BMKTestLocationViewController()
            vc.isAddChatRoom = true
            vc.addChatRoomBlock = {
                self.addChatRoomState = true
            }
            self.navigationController?.pushViewController(vc, animated: true)
        case 23:
            let vc = CommunityHelpViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension PopularCommunityViewController:UITableViewDelegate,UITableViewDataSource{
    
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
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.dataList.count > 0 {
            let hotModel = self.dataList[indexPath.section]
            if (hotModel.type != nil) && hotModel.type == "custom" {
                return 73.0
            }
        }
        
        return 250.0
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
        if (hotModel.type != nil) && hotModel.type == "custom" {
            cell.coverIcon.isHidden = true
        }else {
            cell.coverIcon.isHidden = false
        }
    }
    
}

extension PopularCommunityViewController:HotCommunityCellProtocol{
    //加入聊天室
    func joinChatRoomFor(index: Int) {
        
//        NotificationCenter.default.post(name: NSNotification.Name("sysMsg"), object: self, userInfo: ["id":"123456"])
        
        let hotModel = self.dataList[index]
        
        authenticateAction(hotModel.roomId!) { (isSuccess) in
            if isSuccess {
                HHTool.showTip("已被移除该聊天室，不可加入", duration: 1)
            }else {
                SCCacheChatRecord.shareInstance().createTable(withRoomId: hotModel.roomId!)
                
                let chatRecords = SCCacheChatRecord.shareInstance().selectData(withRoomId: hotModel.roomId!) as! [String]
                
                JGUserLoginService.jg_enterchatRoom(roomId: hotModel.roomId!) { (conversation , error) in
                    if error == nil && conversation != nil{
                        
                        let chatRoomVC:HHChatRoomViewController = HHChatRoomViewController.init(conversation: conversation!, isJoinChat: false, navTitle: hotModel.roomName!)
                        chatRoomVC.takeImage = UIImage.init(fromURLString: hotModel.thumbnails)
                        chatRoomVC.shareTakeUrl = hotModel.thumbnails
                        
                        chatRoomVC.chatRecords = chatRecords
                        self.pushPage(chatRoomVC, animated: true)
                        if let roomid = hotModel.roomId {
                            self.updateList(roomid)
                        }
                        
                    }
                }
            }
        }

        
    }
    // 首页更新缓存列表（点击进入社区时调用）
    func updateList(_ roomID: String) {
        

        let tmp = String(format: "/v1/2.0/hotChatRoom/updateList?roomId=%@&token=%@", roomID,SCCacheTool.shareInstance().getUserToken())
        
        SCNetwork.shareInstance()?.hh_post(withUrl: tmp, params: [:], showLoading: false, call: { (baseModel, error) in
            
        })
    }
    //验证用户是否为该聊天室的删除成员
    func authenticateAction(_ roomId: String, finished:@escaping (_ isSuccess: Bool)->Void) {
        
        SCNetwork.shareInstance().hh_Get(withUrl: "/jm/room/blackMember/authenticate", parameters: ["roomId":roomId,"token":SCCacheTool.shareInstance()?.getUserToken()], showLoading: false) { (baseModel, error) in
            
            if let code = baseModel?.code, let data = baseModel?.data as? Int {
                if code == "000000" && data == 1{
                    finished(true)
                }else {
                    finished(false)
                }
            }else {
                finished(false)
            }
        }
    }
}
extension PopularCommunityViewController: UISearchBarDelegate {
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        if self.dataList.count < 1 {
            self.noDataTipDismiss()
            self.tableView.isScrollEnabled = true
            
        }
        self.page = 0
        self._requstData(false, {})
    }
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text ?? "")
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        //SearchRoom_URL
        SCNetwork.shareInstance().hh_Get(withUrl: SearchRoom_URL, parameters: ["roomName":searchBar.text ?? "","token":SCCacheTool.shareInstance().getUserToken()], showLoading: true) { (model, error) in
            
            if error != nil{
                return
            }
            if let tmpModel = model {
                let data = tmpModel.data as? [Any]
                
//                let content = data!["content"] as? [Any]
                
                if data?.count  == 0{
                    self.noDataTipShow(self.tableView, content:NSLocalizedString("sc_Nodata", comment: "字符串"), image: UIImage.loadImage("sc_com_icon_blankPage"), backgroundColor: SC_ThemeBackgroundViewColor)
                    self.dataList = []
                    self.tableView.isScrollEnabled = false
                    self.tableView.reloadData()
                    return;
                }
                if let datas:[HotCommunityModel] = [HotCommunityModel].deserialize(from: data) as? [HotCommunityModel]{
                    self.noDataTipDismiss()
                    self.dataList = datas
                    self.tableView.isScrollEnabled = true
                    self.tableView.reloadData()
//                    self.tableView.scrollsToTop = true
                    self.tableView.mj_footer = nil
                }
            }

        }
    }
}
