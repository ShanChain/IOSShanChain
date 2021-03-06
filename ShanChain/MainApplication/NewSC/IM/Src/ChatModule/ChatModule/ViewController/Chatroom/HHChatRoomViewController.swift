//
//  HHChatRoomViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/10/25.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit
import YHPhotoKit
import MobileCoreServices
import ASExtendedCircularMenu

class HHChatRoomViewController: UIViewController,ASCircularButtonDelegate{
    
    @IBOutlet weak var joinChatViewHeight: NSLayoutConstraint!
    @IBOutlet weak var taskButton: ASCircularMenuButton!
    
    @IBOutlet weak var joinCahtView: UIView!
    var suspendBallBtn:SuspendBall?
    
    
    @IBOutlet weak var enterChatBtn: UIButton!
    open var conversation: JMSGConversation
    var maskView:UIView! // 蒙版
    var takeImage:UIImage? // 分享的区域截图
    var shareTakeUrl:String? // 分享的区域截图的URL
    var isActivitying:Bool = false // 活动是否正在进行中
    
    /// 缓存 历史消息 数组
    var chatRecords:[String] = []
    ///
    var isChatRecordLoad = false
    /// 缓存 历史消息 数组 最后一个数据的 ServerMessageId
    var charRecordsLastServerMessageId: String?
    ///
    var chatImageMessages:[JMSGMessage] = []
    
    
    //MARK - life cycle
    // 通过requite关键字强制子类对某个初始化方法进行重写，也就是说必须要实现这个方法。
    @objc public required init(conversation: JMSGConversation, isJoinChat:Bool, navTitle:String) {
        self.navTitle = navTitle
        self.conversation = conversation
        self.isJoinChatRoom = isJoinChat
        super.init(nibName: "HHChatRoomViewController", bundle: nil) // 加载xib视图
        automaticallyAdjustsScrollViewInsets = false;
       // self.title = navTitle
        if let draft = JCDraft.getDraft(conversation) {
            // 不为空时执行
            self.draft = draft // 获取编辑未发出的草稿
        }
        
        SCCacheTool.shareInstance().chatRoomId = self.currentChatRoomID
//        SCNetwork.shareInstance().v1_post(withUrl: "/jm/room/message", params: ["roomId":self.currentChatRoomID!,"timeStamp":Int(NSDate().timeIntervalSince1970 * 1000)], showLoading: false) { (baseModel, error) in
//
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        _init()
        maskView = UIView.init(frame:chatView.frame)
        //        maskView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(hiddenMaskView)))
        let suspendBall:SuspendBall = SuspendBall.init(frame: CGRect(x: SCREEN_WIDTH - 50, y: UIDevice().navBarHeight + 10, width: 50, height: 50), delegate: self as SuspendBallDelegte, subBallImageArray: [NSLocalizedString("sc_H", comment: "字符串"),NSLocalizedString("sc_P", comment: "字符串"),NSLocalizedString("sc_L", comment: "字符串")])
        suspendBallBtn = suspendBall
        suspendBallBtn?.isHidden = true
        suspendBallBtn?.bottomLayGuide = toolbar.contentSize.height
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        maskView.isHidden = true
        view.addSubview(maskView)
        view.bringSubviewToFront(maskView)
        view.bringSubviewToFront(taskButton)
        view.bringSubviewToFront(joinCahtView)

//        view.addSubview(suspendBallBtn!)// 添加悬浮按钮
//        view.bringSubviewToFront(suspendBallBtn!)


        if isIPhoneX{
            joinChatViewHeight.constant = 82
        }

//        _configureDraggebleCircularMenuButton()
        
    
    }
    
    //    func hiddenMaskView(){
    //        maskView.isHidden = true
    //    }
    
    let colourArray: [UIColor] = [.red , .blue , .green]
    func _configureDraggebleCircularMenuButton(){
        
        configureDraggebleCircularMenuButton(button: taskButton, numberOfMenuItems: 3, menuRedius: 300, postion: .centerTop)
        taskButton.menuButtonSize = .medium
        // taskButton.sholudMenuButtonAnimate = false
//        taskButton.bottomLayouSafeBorder = toolbar.intrinsicContentSize.height
        taskButton.isHidden = true
    }
    
    func buttonForIndexAt(_ menuButton: ASCircularMenuButton, indexForButton: Int) -> UIButton {
        let button: UIButton = UIButton()
        if menuButton == taskButton{
            button.backgroundColor = colourArray[indexForButton]
        }
        return button
    }
    
    func didClickOnCircularMenuButton(_ menuButton: ASCircularMenuButton, indexForButton: Int, button: UIButton) {
        let appointmentVC = AppointmentListViewController()
        self.navigationController?.pushViewController(appointmentVC, animated: true)
    }
    
    override func loadView() {
        super.loadView()
        edgesForExtendedLayout = .all
        let frame = CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64)
        chatView = JCChatView(frame: frame, chatViewLayout: chatViewLayout)
        chatView.delegate = self
        chatView.messageDelegate = self
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.delegate = self
        toolbar.text = draft
    }
        
    func willShowForMenuButton(){
        maskView.isHidden = false
    }
    
    func didDisappearForMenuButton(){
        maskView.isHidden = true
    }
    
    
    // 是否是超级用户
    func _isSuper(_ complete: @escaping (_ isSuper:Bool) -> ()) {
        SCNetwork.shareInstance().getWithUrl(IsSuper_URL, parameters:[:], success: { (result) in
            if let  result = result as? Dictionary<String, Any>{
                if (result["data"] as? Bool) == true{
                    complete (true)
                }else{
                    complete (false)
                }
            }else{
                complete (false)
            }
            
        }) { (error) in
            complete (false)
        }
    }
    
    @IBAction func joinAction(_ sender: Any) {
        
        HHTool.showChrysanthemum()
        _isSuper { (isSuper) in
            if isSuper == true{
                self.isJoinChatRoom = true
                HHTool.immediatelyDismiss()
            }else{
                SCNetwork.shareInstance().getWithUrl(COORDINATE_URL, parameters:["latitude":String(SCCacheTool.shareInstance().pt.latitude),"longitude":String(SCCacheTool.shareInstance().pt.longitude)], success: { (result) in
                    HHTool.immediatelyDismiss()
                    let dic = result as! Dictionary<String, Any>
                    let data = dic["data"] as? Dictionary<String, Any>
                    if data != nil && (data?.values.count)! > 0{
                        let roomId:String = data!["roomId"] as! String
                        if roomId == self.currentChatRoomID{
                            self.isJoinChatRoom = true
//                            if SCCacheTool.shareInstance().status ==  "1" {
//                                self.taskButton.isHidden = false
//                            }
                        }else{
                            self.hrShowAlert(withTitle: "温馨提示", message: "您未处于该元社区的地理位置，还不能加入聊天喔~")
                        }
                    }
                    
                }) { (error) in
                    HHTool.immediatelyDismiss()
                    HHTool.showError(error?.localizedDescription)
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navTitleView?.isHidden = false
        if !isJoinChatRoom {
            toolbar.isHidden = true
            joinCahtView.isHidden = false
            suspendBallBtn?.isHidden = true
        }else{
            toolbar.isHidden = false
            joinCahtView.isHidden = true

            if SCCacheTool.shareInstance().status ==  "1" {
                suspendBallBtn?.isHidden = false
            }

        }

        navigationController?.navigationBar.barTintColor = .white


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        navTitleView.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        // 增加侧滑返回
        //  navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    fileprivate var currentChatRoomID:String?{
        if conversation.conversationType == .chatRoom{
            let chatRoom = conversation.target as? JMSGChatRoom
            return  chatRoom?.roomID
        }
        return ""
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isTranslucent = true
        // 更新草稿内容
        JCDraft.update(text: toolbar.text, conversation: conversation)
        JMessage.remove(self, with: conversation)// 移除监听(delegate)
        //        if conversation.conversationType == .chatRoom{
        //            let chatRoom = conversation.target as? JMSGChatRoom
        //            JMSGChatRoom.leaveChatRoom(withRoomId: (chatRoom?.roomID)!, completionHandler: nil)
        //        }
    }
    
    deinit {
        //析构函数 类似OC的delloc
        NotificationCenter.default.removeObserver(self)
        navTitleView.removeFromSuperview()
        print("析构函数-deinit",self.debugDescription)
    }
    
    private var draft: String?
    private var navTitle:String?
    fileprivate var isJoinChatRoom:Bool = false{
        willSet{
            if !newValue {
                toolbar.isHidden = true
                joinCahtView.isHidden = false
                suspendBallBtn?.isHidden = true
            }else{
                toolbar.isHidden = false
                joinCahtView.isHidden = true
                if SCCacheTool.shareInstance().status == "1"{
                    suspendBallBtn?.isHidden = false
                }
            }
        }
    }
    var _taskModel:TaskAddModel?
    
    // 底部toolBar
    fileprivate lazy var toolbar: SAIInputBar = SAIInputBar(type: .default)
    fileprivate lazy var inputViews: [String: UIView] = [:]
    fileprivate weak var inputItem: SAIInputItem?
    var chatViewLayout: JCChatViewLayout = .init()
    var chatView: JCChatView!
    fileprivate lazy var reminds: [JCRemind] = []
    //UIDocumentInteractionController  强大的文档阅读器
    fileprivate lazy var documentInteractionController = UIDocumentInteractionController()
    
    fileprivate lazy var imagePicker: UIImagePickerController = {
        var picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = self
        return picker
    }()
    
    fileprivate lazy var videoPicker: UIImagePickerController = {
        var picker = UIImagePickerController()
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.sourceType = .camera
        picker.cameraCaptureMode = .video
        picker.videoMaximumDuration = 10
        picker.delegate = self
        return picker
    }()
    
    
    
    // 表情对象数组
    fileprivate lazy var _emoticonGroups: [JCCEmoticonGroup] = {
        var groups: [JCCEmoticonGroup] = []
        if let group = JCCEmoticonGroup(identifier: "com.apple.emoji") {
            groups.append(group)
        }
        if let group = JCCEmoticonGroup(identifier: "cn.jchat.guangguang") {
            groups.append(group)
        }
        return groups
    }()
    // emoji发送按钮
    fileprivate lazy var _emoticonSendBtn: UIButton = {
        var button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10 + 8, bottom: 0, right: 8)
        button.setTitle(NSLocalizedString("sc_send", comment: "字符串"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage.loadImage("chat_emoticon_btn_send_blue"), for: .normal)
        button.setBackgroundImage(UIImage.loadImage("chat_emoticon_btn_send_gray"), for: .disabled)
        
        button.addTarget(self, action: #selector(_sendHandler), for: .touchUpInside)
        return button
    }()
    // emoji展示视图
    fileprivate lazy var emoticonView: JCEmoticonInputView = {
        let emoticonView = JCEmoticonInputView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 275))
        emoticonView.delegate = self
        emoticonView.dataSource = self
        return emoticonView
    }()
    // 点击+显示  消息类型展示视图
    fileprivate lazy var toolboxView: SAIToolboxInputView = {
        var toolboxView = SAIToolboxInputView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 197))
        toolboxView.delegate = self
        toolboxView.dataSource = self
        return toolboxView
    }()
    // 消息类型展示视图内容  icon和title
    fileprivate lazy var _toolboxItems: [SAIToolboxItem] = {
        return [
            SAIToolboxItem("page:pic", "照片", UIImage.loadImage("chat_tool_pic")),
            SAIToolboxItem("page:camera", NSLocalizedString("sc_takePhoto", comment: "字符串"), UIImage.loadImage("chat_tool_camera")),
            SAIToolboxItem("page:video_s", "小视频", UIImage.loadImage("chat_tool_video_short")),
            //            SAIToolboxItem("page:location", "位置", UIImage.loadImage("chat_tool_location")),
            //            SAIToolboxItem("page:businessCard", "名片", UIImage.loadImage("chat_tool_businessCard")),
        ]
    }()
    
    fileprivate var myAvator: UIImage?
    lazy var messages: [JCMessage] = []
    fileprivate let currentUser = JMSGUser.myInfo()
    fileprivate var messagePage = 0
    fileprivate var currentMessage: JCMessageType!
    fileprivate var maxTime = 0
    fileprivate var minTime = 0
    fileprivate var minIndex = 0
    fileprivate var jMessageCount = 0
    fileprivate var isFristLaunch = true
    fileprivate var recordingHub: JCRecordingView!
    fileprivate var navTitleView:RoomNavTitleView!
    fileprivate lazy var recordHelper: JCRecordVoiceHelper = {
        let recordHelper = JCRecordVoiceHelper()
        recordHelper.delegate = self
        return recordHelper
    }()
    
    private func _init() {
        
        
        myAvator = UIImage.getMyAvator()
        //  _updateTitle()
        view.backgroundColor = .white
        JMessage.add(self, with: nil)
        JMessage.setDebugMode()
        _setupNavigation()
        _loadMessage(messagePage) // 加载会话消息
        // 添加点击视图回收键盘手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(_tapView))
        tap.delegate = self
        chatView.addGestureRecognizer(tap)
        view.addSubview(chatView)
        

        // 本地缓存
        if self.chatRecords.count > 0 {
            
            let tmp = JMSGMessage.fromJson(self.chatRecords.last!)
            self.charRecordsLastServerMessageId = tmp?.serverMessageId
            
            isChatRecordLoad = true
            
            for chatRecord in self.chatRecords {

                let msg = JMSGMessage.fromJson(chatRecord)

                _handleMessage(message: msg!)

            }

        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_removeAllMessage), name: NSNotification.Name(rawValue: kDeleteAllMessage), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_reloadMessage), name: NSNotification.Name(rawValue: kReloadAllMessage), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_updateFileMessage(_:)), name: NSNotification.Name(rawValue: kUpdateFileMessage), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_closeChatRoom), name: NSNotification.Name.jmsgNetworkDidClose, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_updateAvatar), name:  NSNotification.Name(rawValue: kUpdateAvatarSuccess), object: nil)
        enterChatBtn.setTitle(NSLocalizedString("sc_Join", comment: "字符串"), for: .normal)
//        // 抽屉
        self.cw_registerShowIntractive(withEdgeGesture: false) { [weak self] (direction) in
            if direction == CWDrawerTransitionDirection.fromLeft{
                self?._maskAnimationFromLeft()
            }
        }
    }
    
    // 运用 lazy 关键字的技巧 来实现 只执行一次（这里之所以这么做，反正就是有个坑没填）
    lazy var receiveChatRoomRecords: Void = {
        
        print(self.currentChatRoomID!,self.chatRecords.count,"0-0-0-0-0-0")
        

    }()
    
    // tcp长链接被关闭
    @objc func _closeChatRoom()  {
       // HHTool.show("广场链接已断开，正在为您重新连接...")
        if HHTool.getCurrentVC() is HHChatRoomViewController{
            EditInfoService.enterChatRoom(withId: self.currentChatRoomID, show: "广场链接已断开，正在为您重新连接...") { (result, error) in
                if let conversation = result as? JMSGConversation{
                    self.conversation = conversation
                }
            }
        }
    }
    
    @objc func _updateFileMessage(_ notification: Notification) {
        let userInfo = notification.userInfo
        let msgId = userInfo?[kUpdateFileMessage] as! String
        let message = conversation.message(withMessageId: msgId)!
        let content = message.content as! JMSGFileContent
        let url = URL(fileURLWithPath: content.originMediaLocalPath ?? "")
        let data = try! Data(contentsOf: url)
        updateMediaMessage(message, data: data)
    }
    
    private func _updateTitle() {
        if let group = conversation.target as? JMSGGroup {
            title = group.displayName()
        } else {
            title = conversation.title
        }
        
    }
    
    // 刷新消息（界面）
    @objc func _reloadMessage() {
        _removeAllMessage()
        messagePage = 0
        _loadMessage(messagePage)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.chatView.scrollToLast(animated: false)// 根据消息滑到指定位置
        }
    }
    
    @objc func _removeAllMessage() {
        jMessageCount = 0
        messages.removeAll()
        chatView.removeAll()
    }
    
    @objc func _tapView() {
        view.endEditing(true)
        toolbar.resignFirstResponder()
    }
    
    @objc func _updateAvatar(){
        let leftImageName = SCCacheTool.shareInstance().characterModel.characterInfo.headImg
        self.addLeftBarButtonItem(withTarget: self, sel: #selector(_maskAnimationFromLeft), imageName: leftImageName, selectedImageName: leftImageName)
    }
    private func _setupNavigation() {
        
        _updateAvatar()
        
        self.addNavigationRight(withImageName: "sc_com_icon_close", withTarget: self, withAction: #selector(_closePage))
        navigationController?.navigationBar.barTintColor = .white

        // titleView
        navTitleView = RoomNavTitleView(frame: CGRect(x: (navigationController?.navigationBar.centerX)! - 100, y: 0, width: 200, height: 50))
        navTitleView.positionBtn .setTitle(self.navTitle, for: .normal)
        if let chatRoom = conversation.target as? JMSGChatRoom{
            if self.navTitle! == "加密聊天社区" {
                navTitleView.numberForPeopleBtn .setTitle("16968人", for: .normal)
            }else {
                navTitleView.numberForPeopleBtn .setTitle("\(chatRoom.totalMemberCount)人", for: .normal)
            }
            
        }
        
        // 查看聊天室成员
        navTitleView.numberForPeopleClosure = {[weak self] () in
            if let chatRoom = self?.conversation.target as? JMSGChatRoom{
                let vc = HHNumberForPeopleViewController.init(count: chatRoom.totalMemberCount, roomId: (self?.currentChatRoomID!)!)
                self?.navigationController?.pushViewController(vc, animated: true)
            }

        }

        
        
        // 分享区域截图
        navTitleView.shareRoomClosure = { [weak self] () in


            if self?.shareTakeUrl == nil {

                HHTool.showChrysanthemum();
                SCAliyunUploadMananger.uploadImage(SCCacheTool.shareInstance().takeImage, withCompressionQuality: 1.0, withCallBack: { (url) in

                    if url != nil{
                        self?._shareTakeImage(url!)
                    }


                }, withErrorCallBack: { (error) in
                    HHTool.showError(error?.localizedDescription)
                })
            }else{
                self?._shareTakeImage((self?.shareTakeUrl)!)
            }
        }

        navTitleView.backgroundColor = UIColor.clear
        navigationController?.navigationBar.addSubview(navTitleView)
//        navTitleView.snp.makeConstraints { (mark) in
//            mark.centerX.centerY.equalTo( (navigationController?.navigationBar)!)
//            mark.width.equalTo(200)
//            mark.height.equalTo(50)
//        }
        //        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        //        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    // 分享接口
    func _shareTakeImage(_ url:String){
        SCNetwork.shareInstance().v1_post(withUrl: ShareRoom_URL, params: ["Img":url,"id":currentChatRoomID!,"characterId":SCCacheTool.shareInstance().getCurrentCharacterId()], showLoading: true) { [weak self] (baseModel, error) in
            
            if error != nil{
                HHTool.showError(error?.localizedDescription)
                return;
            }
            
            if let dic = baseModel?.data as? Dictionary<String,Any>{
                let shareModel:CommonShareModel =  CommonShareModel.init()
                shareModel.url = dic["url"] as? String
                shareModel.title = dic["title"] as? String
                shareModel.intro = dic["intro"] as? String
                shareModel.background = dic["background"] as? String
                let shareView:HHShareView = HHShareView.init(frame: ((self?.view.frame)!), shareImage: self?.takeImage ?? SCCacheTool.shareInstance().takeImage, type: 2, shareModel: shareModel)
                
                shareView.closure = {[weak self] () in
                    self?.navTitleView.positionBtn.isEnabled = true
                }
                self?.view.addSubview(shareView)
                if self?.isJoinChatRoom == true{
                    self?.toolbar.isHidden = true
                    shareView.closure = {[weak self] () in
                        self?.toolbar.isHidden = false
                    }
                }
                
                
            }
            
        }
        
    }
    
    @objc func _closePage(){
        // 从登录页rootViewController过来的
        if navigationController?.viewControllers.count == 1 {
            
        }
        self.hrShowAlert(withTitle: nil, message: NSLocalizedString("sc_LeaveCommunity", comment: "字符串"), buttonsTitles: [NSLocalizedString("sc_confirm", comment: "字符串"),NSLocalizedString("sc_cancel", comment: "字符串")]) { [weak self] (action, index) in
            if index == 0{
                
                if let player = JCAudioPlayerHelper.sharedInstance.player {
                    if player.isPlaying {
                        JCAudioPlayerHelper.sharedInstance.stopAudio()
                    }
                }
                self?.navigationController?.popToRootViewController(animated: true)
//                这里暂时不做退出聊天室
//                JMSGChatRoom.leaveChatRoom(withRoomId: (self?.currentChatRoomID)!, completionHandler: { (_, _) in
////                    self.navigationController?.popViewController(animated: true)
//                    self?.navigationController?.popToRootViewController(animated: true)
//                })
                
            }
        }
        
    }
    
    @objc func _maskAnimationFromLeft(){
        let vc = LeftViewController()
        self.cw_showDrawerViewController(vc, animationType: CWDrawerAnimationType.mask, configuration: nil)
    }
    
    
    
    fileprivate func _loadMessage(_ page: Int) {
        // 分页获取消息
        let messages:[JMSGMessage] = conversation.messageArrayFromNewest(withOffset: NSNumber(value: jMessageCount), limit: NSNumber(value: 17))
        if messages.count == 0 {
            return
        }
        var msgs: [JCMessage] = []
        for index in 0..<messages.count {
            let message = messages[index]
            let msg = _parseMessage(message)
            msgs.insert(msg, at: 0)
            if isNeedInsertTimeLine(message.timestamp.intValue) || index == messages.count - 1 {
                let timeContent = JCMessageTimeLineContent(date: Date(timeIntervalSince1970: TimeInterval(message.timestamp.intValue / 1000)))
                let m = JCMessage(content: timeContent)
                m.options.showsTips = false
                msgs.insert(m, at: 0)
            }
        }
        if page != 0 {
            minIndex = minIndex + msgs.count
            chatView.insert(contentsOf: msgs, at: 0)
        } else {
            minIndex = msgs.count - 1
            chatView.append(contentsOf: msgs)// msgs:[JCMessage]
        }
        self.messages.insert(contentsOf: msgs, at: 0)
    }
    
    func isNeedInsertTimeLine(_ time: Int) -> Bool {
        if maxTime == 0 || minTime == 0 {
            maxTime = time
            minTime = time
            return true
        }
        if (time - maxTime) >= 5 * 60000 { // 超过五分钟显示时间
            maxTime = time
            return true
        }
        if (minTime - time) >= 5 * 60000 { // 少于当前消息列表五分钟显示时间
            minTime = time
            return true
        }
        return false
    }
    
    // MARK: - parse message
    fileprivate func _parseMessage(_ message: JMSGMessage, _ isNewMessage: Bool = true)  -> JCMessage {
        if isNewMessage {
            jMessageCount += 1
        }
        
        return message.parseMessage(self, { [weak self] (message, data) in
            self?.updateMediaMessage(message, data: data)
        })
    }
    
    // MARK: - send message
    // 所有发送的消息最终都会走到这里统一处理
    func send(_ message: JCMessage, _ jmessage: JMSGMessage) {
        if isNeedInsertTimeLine(jmessage.timestamp.intValue) {// 是否显示时间
            let timeContent = JCMessageTimeLineContent(date: Date(timeIntervalSince1970: TimeInterval(jmessage.timestamp.intValue / 1000)))
            let m = JCMessage(content: timeContent)
            m.options.showsTips = false
            messages.append(m)
            chatView.append(m)
        }
        message.msgId = jmessage.msgId
        message.name = currentUser.displayName()
        message.sender = currentUser
        message.options.alignment = .right
        message.options.state = .sending
        currentUser.thumbAvatarData { (data, username, error) in
            if let imageData = data {
                let image = UIImage(data: imageData)
                message.senderAvator = image
            } else {
                message.senderAvator = self.myAvator
            }
        }
        
        
        if let group = conversation.target as? JMSGGroup {
            message.targetType = .group
            message.unreadCount = group.memberArray().count - 1
        } else {
            if let chatRoom = conversation.target as? JMSGChatRoom{
                message.targetType = .chatRoom
                message.unreadCount = chatRoom.totalMemberCount
            }else{
                message.targetType = .single
                message.unreadCount = 1
            }
            
        }
        chatView.append(message)
        messages.append(message)
        chatView.scrollToLast(animated: false)
        conversation.send(jmessage, optionalContent: JMSGOptionalContent.ex.default)
        
        SCCacheChatRecord.shareInstance()?.deleteData(withRoomId: self.currentChatRoomID)
    }
    // 发送文本
    func send(forText text: NSAttributedString) {
        
        if text.string.isEmpty{
            return
        }
        
        let message = JCMessage(content: JCMessageTextContent(attributedText: text))
        let content = JMSGTextContent(text: text.string)
        let msg = JMSGMessage.ex.createMessage(conversation, content, reminds)
        reminds.removeAll()
        send(message, msg)
        
    }
    // 发送自定义消息
    func send(forCustom customDictionary:NSDictionary){
        let customMessage = JCMessage(content: HHPublishTaskContent(customDictionary: customDictionary as! Dictionary<String, Any>, delegate: self))
        let customContent = JMSGCustomContent.init(customDictionary: customDictionary as? [AnyHashable : Any])
        let customMsg = JMSGMessage.ex.createMessage(conversation, customContent, nil)
        send(customMessage, customMsg)
    }
    
    // 发送emoji
    func send(forLargeEmoticon emoticon: JCCEmoticonLarge) {
        guard let image = emoticon.contents as? UIImage else {
            return
        }
        let messageContent = JCMessageImageContent()
        messageContent.image = image
        messageContent.delegate = self
        let message = JCMessage(content: messageContent)
        
        let content = JMSGImageContent(imageData: image.jpegData(compressionQuality: 1.0)!)
        let msg = JMSGMessage.ex.createMessage(conversation, content!, nil)
        msg.ex.isLargeEmoticon = true
        message.options.showsTips = true
        send(message, msg)
    }
    // 发送图片
    func send(forImage image: UIImage) {
        let data = image.jpegData(compressionQuality: 1.0)!
        let content = JMSGImageContent(imageData: data)
        //
        content?.addStringExtra(JMSSAGE_APPKEY, forKey: JM_APPKET)
        content?.addStringExtra(SCCacheTool.shareInstance().getHxUserName(), forKey: JM_USERNAME)
        if  ((conversation.target as? JMSGGroup) != nil) {
            content?.addStringExtra("group", forKey: JM_COMVERSATION_TYPE)
        } else {
            if conversation.target is JMSGChatRoom{
                content?.addStringExtra("chatRoom", forKey: JM_COMVERSATION_TYPE)
            }else{
                content?.addStringExtra("single", forKey: JM_COMVERSATION_TYPE)
            }
            
        }
        
        let message = JMSGMessage.ex.createMessage(conversation, content!, nil)
        let imageContent = JCMessageImageContent()
        imageContent.delegate = self
        imageContent.image = image
        content?.uploadHandler = {  (percent:Float, msgId:(String?)) -> Void in
            imageContent.upload?(percent)
        }
        let msg = JCMessage(content: imageContent)
        msg.contentType = .image
        send(msg, message)
        
    }
    // 发送音频
    func send(voiceData: Data, duration: Double) {
        let voiceContent = JCMessageVoiceContent()
        voiceContent.data = voiceData
        voiceContent.duration = duration
        voiceContent.delegate = self
        let content = JMSGVoiceContent(voiceData: voiceData, voiceDuration: NSNumber(value: duration))
        let message = JMSGMessage.ex.createMessage(conversation, content, nil)
        
        let msg = JCMessage(content: voiceContent)
        msg.contentType = .voice
        send(msg, message)
    }
    // 发送文件
    func send(fileData: Data) {
        let videoContent = JCMessageVideoContent()
        videoContent.data = fileData
        videoContent.delegate = self
        
        let content = JMSGFileContent(fileData: fileData, fileName: "小视频")
        let message = JMSGMessage.ex.createMessage(conversation, content, nil)
        message.ex.isShortVideo = true
        let msg = JCMessage(content: videoContent)
        send(msg, message)
    }
    
    // 发送视频
    func send(videoData: Data,videoUrl :URL) {
        let videoContent = JCMessageVideoContent()
        videoContent.data = videoData
        videoContent.delegate = self
        let dic = HHTool.getVideoInfo(withSourcePath: videoUrl)
        let duration:NSNumber = dic!["duration"] as! NSNumber
        
        let content = JMSGVideoContent(videoData: videoData, thumbData:HHTool.getVideoPreViewImage(videoUrl).jpegData(compressionQuality: 1.0)!, duration:duration)
        let message = JMSGMessage.ex.createMessage(conversation, content, nil)
        message.ex.isShortVideo = true
        let msg = JCMessage(content: videoContent)
        msg.contentType = .video
        send(msg, message)
        
    }
    
    
    // 发送地址
    func send(address: String, lon: NSNumber, lat: NSNumber) {
        let locationContent = JCMessageLocationContent()
        locationContent.address = address
        locationContent.lat = lat.doubleValue
        locationContent.lon = lon.doubleValue
        locationContent.delegate = self
        
        let content = JMSGLocationContent(latitude: lat, longitude: lon, scale: NSNumber(value: 1), address: address)
        let message = JMSGMessage.ex.createMessage(conversation, content, nil)
        let msg = JCMessage(content: locationContent)
        send(msg, message)
    }
    // 键盘发送改变通知
    @objc func keyboardFrameChanged(_ notification: Notification) {
        let dic = NSDictionary(dictionary: (notification as NSNotification).userInfo!)
        let keyboardValue = dic.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let bottomDistance = UIScreen.main.bounds.size.height - keyboardValue.cgRectValue.origin.y
        let duration = Double(dic.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! NSNumber)
        
        UIView.animate(withDuration: duration, animations: {
        }) { (finish) in
            if (bottomDistance == 0 || bottomDistance == self.toolbar.height) && !self.isFristLaunch {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.chatView.scrollToLast(animated: false)
            }
            self.isFristLaunch = false
        }
    }
    // 点击emoji发送按钮发送编辑好的文本
    @objc func _sendHandler() {
        let text = toolbar.attributedText
        if text != nil && (text?.length)! > 0 {
            send(forText: text!)
            toolbar.attributedText = nil
        }
    }
    // 单聊 进入聊天设置
    func _getSingleInfo() {
        let vc = JCSingleSettingViewController()
        vc.user = conversation.target as! JMSGUser
        navigationController?.pushViewController(vc, animated: true)
    }
    // 群聊 进入群聊设置
    func _getGroupInfo() {
        let vc = JCGroupSettingViewController()
        let group = conversation.target as! JMSGGroup
        vc.group = group
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - JMSGMessage Delegate
extension HHChatRoomViewController: JMessageDelegate {
    
    
    // 更新媒体消息
    fileprivate func updateMediaMessage(_ message: JMSGMessage, data: Data) {
        DispatchQueue.main.async {
            if let index = self.messages.index(message) {
                let msg = self.messages[index]
                switch(message.contentType) {
                case .file:
                    if message.ex.isShortVideo {
                        let videoContent = msg.content as! JCMessageVideoContent
                        videoContent.data = data
                        videoContent.delegate = self
                        msg.content = videoContent
                    } else {
                        let fileContent = msg.content as! JCMessageFileContent
                        fileContent.data = data
                        fileContent.delegate = self
                        msg.content = fileContent
                    }
                case .image:
                    let imageContent = msg.content as! JCMessageImageContent
                    let image = UIImage(data: data)
                    imageContent.image = image
                    msg.content = imageContent
                default: break
                }
                msg.updateSizeIfNeeded = true
                self.chatView.update(msg, at: index)
                msg.updateSizeIfNeeded = false
                //                self.chatView.update(msg, at: index)
            }
        }
    }

    
    
    // 接收聊天室的消息
    func onReceiveChatRoomConversation(_ conversation: JMSGConversation!, messages: [JMSGMessage]!) {
        // MARK: - Warning 注意释放对象，不然这里就会出现奇妙的现象！
        
        let tmp = messages.last!
        let serverMessageId = tmp.serverMessageId!
        // 有缓存
        if let tmp1 = self.charRecordsLastServerMessageId {
            // 不是最新的 缓存过期，需要更新
            if serverMessageId != tmp1 {
                self.chatImageMessages = []
                if isChatRecordLoad {
                    //第一次 清空聊天消息 重载(不在聊天室内，就要加载)
                    self._reloadMessage()
                    
                    isChatRecordLoad = false
                }
                messages.forEach { [weak self] (msg) in
                    _handleMessage(message: msg)
                    let msgJsonString = msg.toJsonString()
                    let msgid = msg.serverMessageId
                    SCCacheChatRecord.shareInstance()?.insertData(withRoomId: self?.currentChatRoomID, msgid: msgid, record: msgJsonString)
                }
            }
        }else {
            messages.forEach { [weak self] (msg) in
                _handleMessage(message: msg)
                let msgJsonString = msg.toJsonString()
                let msgid = msg.serverMessageId
                SCCacheChatRecord.shareInstance()?.insertData(withRoomId: self?.currentChatRoomID, msgid: msgid, record: msgJsonString)
            }
        }
//        for message in messages{
//
//            if let tmp1 = self.charRecordsLastServerMessageId {
//                if serverMessageId != tmp1 {
//                    if isChatRecordLoad {
//                        //第一次 清空聊天消息 重载(不在聊天室内，就要加载)
//                        self._reloadMessage()
//
//                        isChatRecordLoad = false
//                    }
//                    self.chatImageMessages = []
//                    _handleMessage(message: message)
//                    // print(serverMessageId,">>>>>>>",tmp1)
//                }else {
//                    // 相等 只能是 第一次
//                }
//            }else {
//                _handleMessage(message: message)
//            }
//
//            let msgJsonString = message.toJsonString()
//            let msgid = message.serverMessageId
//
//            SCCacheChatRecord.shareInstance()?.insertData(withRoomId: self.currentChatRoomID, msgid: msgid, record: msgJsonString)
//        }
        if isChatRecordLoad {
            isChatRecordLoad = false
        }

//        for message in messages{
//            _handleMessage(message: message)
//        }
        print("当前房间ID",self.currentChatRoomID!,chatRecords.count,"0-0-0-0-0-0")
        if !self.chatView.isRoll {
            self.chatView.scrollToLast(animated: true)
        }

    }
    // 接收消息(服务器端下发的)回调
//    func onReceive(_ message: JMSGMessage!, error: Error!) {
//        if error != nil {
//            return
//        }
//        
//        _handleMessage(message: message)
//    }
    // 处理接收到的消息 
    func _handleMessage(message:JMSGMessage){
        
        
//        DispatchQueue.global(qos: .default).async {
//            let message =  self._parseMessage(message)
//            DispatchQueue.main.async {
//                self.messages.append(message)
//                self.chatView.append(message)
//                self.updateUnread([message])
//                self.conversation.clearUnreadCount()
//                if !self.chatView.isRoll {
//                    self.chatView.scrollToLast(animated: true)
//                }
//            }
//        }
        if message.contentType == .image {
            self.chatImageMessages.append(message)
        }
        //修改聊天室历史消息排序问题,之前用了异步导致排序问题 -R
        let msg =  self._parseMessage(message)

        
        //添加 消息历史 时间线
        if isNeedInsertTimeLine(message.timestamp.intValue) {// 是否显示时间
            let timeContent = JCMessageTimeLineContent(date: Date(timeIntervalSince1970: TimeInterval(message.timestamp.intValue / 1000)))
            let m = JCMessage(content: timeContent)
            m.options.showsTips = false
            self.messages.append(m)
            self.chatView.append(m)
        }
        self.messages.append(msg)
        self.chatView.append(msg)
        self.updateUnread([msg])
        self.conversation.clearUnreadCount()
        
        
        // TODO: 这个判断是sdk bug导致的，暂时只能这么改
        //        if self.messages.contains(where: { (m) -> Bool in
        //            return m.msgId == message.msgId
        //        }) {
        //            // 聊天室消息本地不会存储
        //            let indexs = chatView.indexPathsForVisibleItems
        //            for index in indexs {
        //                var m = self.messages[index.row]
        //                if !m.msgId.isEmpty {
        //                    do{
        //                        m =   self._parseMessage((conversation.message(withMessageId: m.msgId))!, false)
        //                        chatView.update(m, at: index.row)
        //                    }catch{
        //                        printLog(error)
        //                    }
        //
        //                }
        //            }
        //            return
        //        }
        
     
    }
    
    // 发送消息成功的回调
    func onSendMessageResponse(_ message: JMSGMessage!, error: Error!) {
        if let error = error as NSError? {
            if error.code == 803009 {
                MBProgressHUD_JChat.show(text: "发送失败，消息中包含敏感词", view: view, 2.0)
            }
            
            if error.code == 803005 {
                MBProgressHUD_JChat.show(text: "您已不是群成员", view: view, 2.0)
            }
        }
        if let index = messages.index(message) {
            let msg = messages[index]
            msg.options.state = message.ex.state
            chatView.update(msg, at: index)
        }
    }
    
    // 监听消息撤回事件
    func onReceive(_ retractEvent: JMSGMessageRetractEvent!) {
        if let index = messages.index(retractEvent.retractMessage) {
            let msg = _parseMessage(retractEvent.retractMessage, false)
            messages[index] = msg
            chatView.update(msg, at: index)
        }
    }
    // 同步离线消息、离线事件通知

    func onSyncOfflineMessageConversation(_ conversation: JMSGConversation!, offlineMessages: [JMSGMessage]!) {
        let msgs = offlineMessages.sorted(by: { (m1, m2) -> Bool in
            return m1.timestamp.intValue < m2.timestamp.intValue
        })
        for item in msgs {
            
            if item.targetType != .chatRoom {
                print("处理单聊消息出现在聊天室里")
                return
            }

            let message = _parseMessage(item)//先解析成JCMessage
            messages.append(message)
            chatView.append(message)
            updateUnread([message]) // 更新状态为已读
            conversation.clearUnreadCount() // 清除会话未读数
            // isRoll 判断用户是否在滚动视图
            if !chatView.isRoll {
                chatView.scrollToLast(animated: true)
            }
        }
        
    }
    
    // 监听消息回执状态变更事件
    func onReceive(_ receiptEvent: JMSGMessageReceiptStatusChangeEvent!) {
        for message in receiptEvent.messages! {
            if let index = messages.index(message) {
                let msg = messages[index]
                msg.unreadCount = message.getUnreadCount()
                chatView.update(msg, at: index)
            }
        }
    }
}

// MARK: - JCEmoticonInputViewDataSource & JCEmoticonInputViewDelegate
extension HHChatRoomViewController: JCEmoticonInputViewDataSource, JCEmoticonInputViewDelegate {
    
    open func numberOfEmotionGroups(in emoticon: JCEmoticonInputView) -> Int {
        return _emoticonGroups.count
    }
    
    open func emoticon(_ emoticon: JCEmoticonInputView, emotionGroupForItemAt index: Int) -> JCEmoticonGroup {
        return _emoticonGroups[index]
    }
    
    open func emoticon(_ emoticon: JCEmoticonInputView, numberOfRowsForGroupAt index: Int) -> Int {
        return _emoticonGroups[index].rows
    }
    
    open func emoticon(_ emoticon: JCEmoticonInputView, numberOfColumnsForGroupAt index: Int) -> Int {
        return _emoticonGroups[index].columns
    }
    
    open func emoticon(_ emoticon: JCEmoticonInputView, moreViewForGroupAt index: Int) -> UIView? {
        if _emoticonGroups[index].type.isSmall {
            return _emoticonSendBtn
        } else {
            return nil
        }
    }
    
    open func emoticon(_ emoticon: JCEmoticonInputView, insetForGroupAt index: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 10, bottom: 12 + 24, right: 10)
    }
    
    open func emoticon(_ emoticon: JCEmoticonInputView, didSelectFor item: JCEmoticon) {
        if item.isBackspace {
            toolbar.deleteBackward()
            return
        }
        if let emoticon = item as? JCCEmoticonLarge {
            send(forLargeEmoticon: emoticon)
            return
        }
        if let code = item.contents as? String {
            return toolbar.insertText(code)
        }
        if let image = item.contents as? UIImage {
            let d = toolbar.font?.descender ?? 0
            let h = toolbar.font?.lineHeight ?? 0
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.bounds = CGRect(x: 0, y: d, width: h, height: h)
            toolbar.insertAttributedText(NSAttributedString(attachment: attachment))
            return
        }
    }
}

// MARK: - SAIToolboxInputViewDataSource & SAIToolboxInputViewDelegate
extension HHChatRoomViewController: SAIToolboxInputViewDataSource, SAIToolboxInputViewDelegate {
    
    open func numberOfToolboxItems(in toolbox: SAIToolboxInputView) -> Int {
        return _toolboxItems.count
    }
    open func toolbox(_ toolbox: SAIToolboxInputView, toolboxItemForItemAt index: Int) -> SAIToolboxItem {
        return _toolboxItems[index]
    }
    
    open func toolbox(_ toolbox: SAIToolboxInputView, numberOfRowsForSectionAt index: Int) -> Int {
        return 2
    }
    open func toolbox(_ toolbox: SAIToolboxInputView, numberOfColumnsForSectionAt index: Int) -> Int {
        return 4
    }
    open func toolbox(_ toolbox: SAIToolboxInputView, insetForSectionAt index: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
    }
    open func toolbox(_ toolbox: SAIToolboxInputView, shouldSelectFor item: SAIToolboxItem) -> Bool {
        return true
    }
    private func _pushToSelectPhotos() {
        let vc = YHPhotoPickerViewController()
        vc.maxPhotosCount = 9;
        vc.pickerDelegate = self
        present(vc, animated: true)
    }
    open func toolbox(_ toolbox: SAIToolboxInputView, didSelectFor item: SAIToolboxItem) {
        toolbar.resignFirstResponder()
        switch item.identifier {
        case "page:pic":
            if PHPhotoLibrary.authorizationStatus() != .authorized {
                PHPhotoLibrary.requestAuthorization({ (status) in
                    DispatchQueue.main.sync {
                        if status != .authorized {
                            // 适配国际化  此处得修改
                            JCAlertView.bulid().setTitle("无权限访问照片").setMessage("请在设备的设置-马甲APP中允许访问照片。").setDelegate(self).addCancelButton("好的").addButton("去设置").setTag(10001).show()
                        } else {
                            self._pushToSelectPhotos()
                        }
                    }
                })
            } else {
                _pushToSelectPhotos()
            }
        case "page:camera":
            present(imagePicker, animated: true, completion: nil)
        case "page:video_s":
            present(videoPicker, animated: true, completion: nil)
        case "page:location":
            let vc = JCAddMapViewController()
            vc.addressBlock = { (dict: Dictionary?) in
                if dict != nil {
                    let lon = Float(dict?["lon"] as! String)
                    let lat = Float(dict?["lat"] as! String)
                    let address = dict?["address"] as! String
                    self.send(address: address, lon: NSNumber(value: lon!), lat: NSNumber(value: lat!))
                }
            }
            navigationController?.pushViewController(vc, animated: true)
        case "page:businessCard":
            let vc = FriendsBusinessCardViewController()
            vc.conversation = conversation
            let nav = JCNavigationController(rootViewController: vc)
            present(nav, animated: true, completion: {
                self.toolbar.isHidden = true
            })
        default:
            break
        }
    }
    
    open override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

// MARK: - UIImagePickerControllerDelegate & YHPhotoPickerViewControllerDelegate
extension HHChatRoomViewController: YHPhotoPickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func selectedPhotoBeyondLimit(_ count: Int32, currentView view: UIView!) {
        MBProgressHUD_JChat.show(text: "最多选择\(count)张图片", view: nil)
    }
    
    func yhPhotoPickerViewController(_ PhotoPickerViewController: YHSelectPhotoViewController!, selectedPhotos photos: [Any]!) {
        for item in photos {
            guard let photo = item as? UIImage else {
                return
            }
            DispatchQueue.main.async {
                self.send(forImage: photo)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage?
        if let image = image?.fixOrientation() {
            send(forImage: image)
        }
        let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as! URL?
        if videoUrl != nil {
            let data = try! Data(contentsOf: videoUrl!)
            //send(fileData: data)
            send(videoData: data, videoUrl: videoUrl!)
            
        }
    }
}

// MARK: - JCMessageDelegate
extension HHChatRoomViewController: JCMessageDelegate {
    
    // 领取任务
    //    func message(message: JCMessageType, receiveTask taskID: String) {
    //        let rect = CGRect(x: 0, y: UIDevice.current.navBarHeight, width: Int(SCREEN_WIDTH), height: Int(SCREEN_HEIGHT) - Int(UIDevice.current.navBarHeight))
    //        let recieveView:RecieveTaskView = RecieveTaskView(frame: rect)
    //        recieveView.closure = {[weak self] (conversation) in
    //            self?.toolbar.isHidden = false
    //        }
    //        self.toolbar.isHidden = true
    //        self.view.addSubview(recieveView)
    //    }
    
    
    
    func clickTaskMessage(message: JCMessageType, tuple: [String : AnyObject]?) {
        let detailsVC = TaskDetailsViewController(taskID: tuple![CUSTOM_TASKID] as! String, content: tuple![CUSTOM_CONTENT] as! String, reward: tuple![CUSTOM_REWARD] as! String, time: tuple![CUSTOM_COMPLETETIME] as! String)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    func message(message: JCMessageType, videoData data: Data?) {
        if let data = data {
            JCVideoManager.playVideo(data: data, currentViewController: self)
        }
    }
    
    func message(message: JCMessageType, location address: String?, lat: Double, lon: Double) {
        let vc = JCAddMapViewController()
        vc.isOnlyShowMap = true
        vc.lat = lat
        vc.lon = lon
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func message(message: JCMessageType, image: UIImage?) {
        
        let browserImageVC = JCImageBrowserViewController()
        browserImageVC.messages = messages
        browserImageVC.conversation = conversation
        browserImageVC.currentMessage = message
        browserImageVC.chatImageMessages = self.chatImageMessages
        if let index = self.chatImageMessages.index(where: { (m) -> Bool in
            m.msgId == message.msgId
        }) {
            browserImageVC.imgCurrentIndex = index
        } else {
            browserImageVC.imgCurrentIndex = 0
        }
        print(self.chatImageMessages.first?.msgId ?? "self.chatImageMessages.first?.msgId nil",message.msgId)
        present(browserImageVC, animated: true) {
            self.toolbar.isHidden = true
        }
    }
    
    // 点击文件
    func message(message: JCMessageType, fileData data: Data?, fileName: String?, fileType: String?) {
        if data == nil {
            let vc = JCFileDownloadViewController()
            vc.title = fileName
            let msg = conversation.message(withMessageId: message.msgId)
            vc.fileSize = msg?.ex.fileSize
            vc.message = msg
            navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let fileType = fileType else {
                return
            }
            let msg = conversation.message(withMessageId: message.msgId)!
            let content = msg.content as! JMSGFileContent
            switch fileType.fileFormat() {
            case .document:
                let vc = JCDocumentViewController()
                vc.title = fileName
                vc.fileData = data
                vc.filePath = content.originMediaLocalPath
                vc.fileType = fileType
                navigationController?.pushViewController(vc, animated: true)
            case .video, .voice:
                let url = URL(fileURLWithPath: content.originMediaLocalPath ?? "")
                try! JCVideoManager.playVideo(data: Data(contentsOf: url), fileType, currentViewController: self)
            case .photo:
                let browserImageVC = JCImageBrowserViewController()
                let image = UIImage(contentsOfFile: content.originMediaLocalPath ?? "")
                browserImageVC.imageArr = [image!]
                browserImageVC.imgCurrentIndex = 0
                present(browserImageVC, animated: true) {
                    self.toolbar.isHidden = true
                }
            default:
                let url = URL(fileURLWithPath: content.originMediaLocalPath ?? "")
                documentInteractionController.url = url
                documentInteractionController.presentOptionsMenu(from: .zero, in: self.view, animated: true)
            }
        }
    }
    // 点击个人名片名片
    func message(message: JCMessageType, user: JMSGUser?, businessCardName: String, businessCardAppKey: String) {
        if let user = user {
            let vc = JCUserInfoViewController()
            vc.user = user
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func clickTips(message: JCMessageType) {
        currentMessage = message
        let alertView = UIAlertView(title: "重新发送", message: "是否重新发送该消息？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "发送")
        alertView.show()
    }
    
    //点击头像
    func tapAvatarView(message: JCMessageType) {
        toolbar.resignFirstResponder()
        if message.options.alignment == .right {
            navigationController?.pushViewController(JCMyInfoViewController(), animated: true)
        } else {
            let vc = JCUserInfoViewController()
            vc.user = message.sender
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func longTapAvatarView(message: JCMessageType) {
        if message.options.alignment == .right {
            return
        }
        toolbar.becomeFirstResponder()
        if let user = message.sender {
            toolbar.text.append("@")
            handleAt(toolbar, NSMakeRange(toolbar.text.length - 1, 0), user, false, user.displayName().length)
        }
    }
    
    func tapUnreadTips(message: JCMessageType) {
        let vc = UnreadListViewController()
        let msg = conversation.message(withMessageId: message.msgId)
        vc.message = msg
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HHChatRoomViewController: JCChatViewDelegate {
    func refershChatView( chatView: JCChatView) {
        messagePage += 1
        _loadMessage(messagePage)
        chatView.stopRefresh()
    }
    
    func deleteMessage(message: JCMessageType) {
        conversation.deleteMessage(withMessageId: message.msgId)
        if let index = messages.index(message) {
            jMessageCount -= 1
            messages.remove(at: index)
            if let message = messages.last {
                if message.content is JCMessageTimeLineContent {
                    messages.removeLast()
                    chatView.remove(at: messages.count)
                }
            }
        }
    }
    
    func forwardMessage(message: JCMessageType) {
        if let message = conversation.message(withMessageId: message.msgId) {
            let vc = JCForwardViewController()
            vc.message = message
            let nav = JCNavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: {
                self.toolbar.isHidden = true
            })
        }
    }
    
    func withdrawMessage(message: JCMessageType) {
        guard let message = conversation.message(withMessageId: message.msgId) else {
            return
        }
        JMSGMessage.retractMessage(message, completionHandler: { (result, error) in
            if error == nil {
                if let index = self.messages.index(message) {
                    let msg = self._parseMessage(self.conversation.message(withMessageId: message.msgId)!, false)
                    self.messages[index] = msg
                    self.chatView.update(msg, at: index)
                }
            } else {
                MBProgressHUD_JChat.show(text: "发送时间过长，不能撤回", view: self.view)
            }
        })
    }
    
    func indexPathsForVisibleItems(chatView: JCChatView, items: [IndexPath]) {
        for item in items {
            if item.row <= minIndex {
                var msgs: [JCMessage] = []
                for index in item.row...minIndex  {
                    msgs.append(messages[index])
                }
                updateUnread(msgs)
                minIndex = item.row
            }
        }
    }
    
    fileprivate func updateUnread(_ messages: [JCMessage]) {
        for message in messages {
            if message.options.alignment != .left {
                continue
            }
            if let msg = conversation.message(withMessageId: message.msgId) {
                if msg.isHaveRead {
                    continue
                }
                msg.setMessageHaveRead({ _,_  in
                    
                })
            }
        }
    }
}

extension HHChatRoomViewController: UIAlertViewDelegate {
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.tag == 10001 {
            if buttonIndex == 1 {
                JCAppManager.openAppSetter()
            }
            return
        }
        switch buttonIndex {
        case 1:
            if let index = messages.index(currentMessage) {
                messages.remove(at: index)
                chatView.remove(at: index)
                let msg = conversation.message(withMessageId: currentMessage.msgId)
                currentMessage.options.state = .sending
                
                if let msg = msg {
                    if let content = currentMessage.content as? JCMessageImageContent,
                        let imageContent = msg.content as? JMSGImageContent
                    {
                        imageContent.uploadHandler = {  (percent:Float, msgId:(String?)) -> Void in
                            content.upload?(percent)
                        }
                    }
                }
                messages.append(currentMessage as! JCMessage)
                chatView.append(currentMessage)
                //                conversation.send(msg!, optionalContent: JMSGOptionalContent.ex.default)
                chatView.scrollToLast(animated: true)
            }
        default:
            break
        }
    }
}

// MARK: - SAIInputBarDelegate & SAIInputBarDisplayable
extension HHChatRoomViewController: SAIInputBarDelegate, SAIInputBarDisplayable {
    
    open override var inputAccessoryView: UIView? {
        return toolbar
    }
    open var scrollView: SAIInputBarScrollViewType {
        return chatView
    }
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open func inputView(with item: SAIInputItem) -> UIView? {
        if let view = inputViews[item.identifier] {
            return view
        }
        switch item.identifier {
        case "kb:emoticon":
            let view = JCEmoticonInputView()
            view.delegate = self
            view.dataSource = self
            inputViews[item.identifier] = view
            return view
        case "kb:toolbox":
            let view = SAIToolboxInputView()
            view.delegate = self
            view.dataSource = self
            inputViews[item.identifier] = view
            return view
            
        case "kb:task":
            return nil
        default:
            return nil
        }
    }
    
    
    open func inputViewContentSize(_ inputView: UIView) -> CGSize {
        return CGSize(width: view.frame.width, height: 216)
    }
    
    func inputBar(_ inputBar: SAIInputBar, shouldDeselectFor item: SAIInputItem) -> Bool {
        return true
    }
    open func inputBar(_ inputBar: SAIInputBar, shouldSelectFor item: SAIInputItem) -> Bool {
        if item.identifier == "kb:audio" {
            return true
        }
        guard let _ = inputView(with: item) else {
            return false
        }
        return true
    }
    open func inputBar(_ inputBar: SAIInputBar, didSelectFor item: SAIInputItem) {
        inputItem = item
        
        if item.identifier == "kb:audio" {
            inputBar.deselectBarAllItem()
            return
        }
        if item.identifier == "kb:task" {
            
            return;
        }
        
        if let kb = inputView(with: item) {
            inputBar.setInputMode(.selecting(kb), animated: true)
        }
    }
    open func inputBar(didChangeMode inputBar: SAIInputBar) {
        if inputItem?.identifier == "kb:audio" {
            return
        }
        if let item = inputItem, !inputBar.inputMode.isSelecting {
            inputBar.deselectBarItem(item, animated: true)
        }
    }
    
    open func inputBar(didChangeText inputBar: SAIInputBar) {
        _emoticonSendBtn.isEnabled = inputBar.attributedText.length != 0
    }
    
    public func inputBar(shouldReturn inputBar: SAIInputBar) -> Bool {
        if inputBar.attributedText.length == 0 {
            return false
        }
        send(forText: inputBar.attributedText)
        inputBar.attributedText = nil
        return false
    }
    
    func inputBar(_ inputBar: SAIInputBar, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let currentIndex = range.location
        return updateRemids(inputBar, string, range, currentIndex)
        //        if string == "@" {
        //            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
        //                let vc = JCRemindListViewController()
        //                vc.finish = { (user, isAtAll, length) in
        //                    self.handleAt(inputBar, range, user, isAtAll, length)
        //                }
        //                vc.chatRoom = self.conversation.target as? JMSGChatRoom
        //                let nav = JCNavigationController(rootViewController: vc)
        //                self.present(nav, animated: true, completion: {})
        //            }
        //        } else {
        //            return updateRemids(inputBar, string, range, currentIndex)
        //        }
        //        return true
    }
    
    func handleAt(_ inputBar: SAIInputBar, _ range: NSRange, _ user: JMSGUser?, _ isAtAll: Bool, _ length: Int) {
        let text = inputBar.text!
        let currentIndex = range.location
        var displayName = "所有成员"
        
        if let user = user {
            displayName = user.displayName()
        }
        let remind = JCRemind(user, currentIndex, currentIndex + 2 + displayName.length, displayName.length + 2, isAtAll)
        if text.length == currentIndex + 1 {
            inputBar.text = text + displayName + " "
        } else {
            let index1 = text.index(text.endIndex, offsetBy: currentIndex - text.length + 1)
            let prefix = text.substring(with: text.startIndex..<index1)
            let index2 = text.index(text.startIndex, offsetBy: currentIndex + 1)
            let suffix = text.substring(with: index2..<text.endIndex)
            inputBar.text = prefix + displayName + " " + suffix
            let _ = self.updateRemids(inputBar, "@" + displayName + " ", range, currentIndex)
        }
        self.reminds.append(remind)
        self.reminds.sort(by: { (r1, r2) -> Bool in
            return r1.startIndex < r2.startIndex
        })
    }
    
    func updateRemids(_ inputBar: SAIInputBar, _ string: String, _ range: NSRange, _ currentIndex: Int) -> Bool {
        for index in 0..<reminds.count {
            let remind = reminds[index]
            let length = remind.length
            let startIndex = remind.startIndex
            let endIndex = remind.endIndex
            // Delete
            if currentIndex == endIndex - 1 && string.length == 0 {
                for _ in 0..<length {
                    inputBar.deleteBackward()
                }
                // Move Other Index
                for subIndex in (index + 1)..<reminds.count {
                    let subTemp = reminds[subIndex]
                    subTemp.startIndex -= length
                    subTemp.endIndex -= length
                }
                reminds.remove(at: index)
                return false;
            } else if currentIndex > startIndex && currentIndex < endIndex {
                // Delete Content
                if string.length == 0 {
                    for subIndex in (index + 1)..<reminds.count {
                        let subTemp = reminds[subIndex]
                        subTemp.startIndex -= 1
                        subTemp.endIndex -= 1
                    }
                    reminds.remove(at: index)
                    return true
                }
                    // Add Content
                else {
                    for subIndex in (index + 1)..<reminds.count {
                        let subTemp = reminds[subIndex]
                        subTemp.startIndex += string.length
                        subTemp.endIndex += string.length
                    }
                    reminds.remove(at: index)
                    return true
                }
            }
        }
        for index in 0..<reminds.count {
            let tempDic = reminds[index]
            let startIndex = tempDic.startIndex
            if currentIndex <= startIndex {
                if string.count == 0 {
                    for subIndex in index..<reminds.count {
                        let subTemp = reminds[subIndex]
                        subTemp.startIndex -= 1
                        subTemp.endIndex -= 1
                    }
                    return true
                } else {
                    for subIndex in index..<reminds.count {
                        let subTemp = reminds[subIndex]
                        subTemp.startIndex += string.length
                        subTemp.endIndex += string.length
                    }
                    return true
                }
            }
        }
        return true
    }
    
    func inputBar(touchDown recordButton: UIButton, inputBar: SAIInputBar) {
        if recordingHub != nil {
            recordingHub.removeFromSuperview()
        }
        recordingHub = JCRecordingView(frame: CGRect.zero)
        recordHelper.updateMeterDelegate = recordingHub
        recordingHub.startRecordingHUDAtView(view)
        recordingHub.frame = CGRect(x: view.centerX - 70, y: view.centerY - 70, width: 136, height: 136)
        recordHelper.startRecordingWithPath(String.getRecorderPath()) {
        }
    }
    
    func inputBar(dragInside recordButton: UIButton, inputBar: SAIInputBar) {
        recordingHub.pauseRecord()
    }
    
    func inputBar(dragOutside recordButton: UIButton, inputBar: SAIInputBar) {
        recordingHub.resaueRecord()
    }
    
    func inputBar(touchUpInside recordButton: UIButton, inputBar: SAIInputBar) {
        if recordHelper.recorder ==  nil {
            return
        }
        recordHelper.finishRecordingCompletion()
        if (recordHelper.recordDuration! as NSString).floatValue < 1 {
            recordingHub.showErrorTips()
            let time: TimeInterval = 1.5
            let hub = recordingHub
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                hub?.removeFromSuperview()
            }
            return
        } else {
            recordingHub.removeFromSuperview()
        }
        let data = try! Data(contentsOf: URL(fileURLWithPath: recordHelper.recordPath!))
        send(voiceData: data, duration: Double(recordHelper.recordDuration!)!)
    }
    
    func inputBar(touchUpOutside recordButton: UIButton, inputBar: SAIInputBar) {
        recordHelper.cancelledDeleteWithCompletion()
        recordingHub.removeFromSuperview()
    }
}

// MARK: - JCRecordVoiceHelperDelegate
extension HHChatRoomViewController: JCRecordVoiceHelperDelegate {
    public func beyondLimit(_ time: TimeInterval) {
        recordHelper.finishRecordingCompletion()
        recordingHub.removeFromSuperview()
        let data = try! Data(contentsOf: URL(fileURLWithPath: recordHelper.recordPath!))
        send(voiceData: data, duration: Double(recordHelper.recordDuration!)!)
    }
}

extension HHChatRoomViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else {
            return true
        }
        if view.isKind(of: JCMessageTextContentView.self) {
            return false
        }
        return true
    }
}

extension HHChatRoomViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        //这个地方需要返回给一个控制器用于展现documentController在其上面，所以我们就返回当前控制器self
        return self
    }
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return view
    }
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return view.frame
    }
}

extension HHChatRoomViewController: SuspendBallDelegte{
    func suspendBall(_ subBall: UIButton!, didSelectTag tag: Int) {
        self.suspendBallBtn?.showFunction =  !(self.suspendBallBtn?.showFunction)!
        if tag == 1 {
            if SCCacheTool.shareInstance().isActivitying == false{
                YYHud.showTip("新玩法开发中，尽请期待！")
            }else{
                self.navigationController?.popViewController(animated: true)
            }
          
            // 发布任务
//            UIView .animate(withDuration: 0.2) {
//                let pubTaskView:PublishTaskView? =
//                    PublishTaskView(taskModel: self._taskModel, frame: CGRect(x: 0, y:0, width: Int(SCREEN_WIDTH), height: Int(SCREEN_HEIGHT)))
//                pubTaskView?.cornerRadius = 0.01
//                pubTaskView?.borderColor = .clear
//                // 点击发布任务回调
//                pubTaskView?.pbCallClosure = { [weak self] (dataString,reward,time,timestamp,isPut)  in
//                    pubTaskView?.dismiss()
//                    self?.toolbar.isHidden = false
//                    if isPut == false{
//                        return
//                    }
//                    let characterId:String = SCCacheTool.shareInstance().getCurrentCharacterId()
//                    let params:Dictionary = ["bounty":reward,"currency":"rmb","dataString":dataString,"roomId":self?.currentChatRoomID ?? "","time":timestamp,"characterId":characterId]
//                    // 添加任务
//                    HHTool.showChrysanthemum()
//                    SCNetwork.shareInstance().v1_post(withUrl: TASK_ADD_URL, params: params, showLoading: true, call: { (baseModel, error) in
//                        HHTool.dismiss()
//                        if((error) != nil){
//                            HHTool .showError("发布失败")
//                            return
//                        }
//                        let dict = baseModel?.data as!Dictionary<String, Any>
//                        if let model = TaskAddModel.deserialize(from: dict) {
//                            self?._taskModel = model
//                            self?.send(forCustom: [CUSTOM_CONTENT:model.Task?.intro ?? "",CUSTOM_REWARD:model.Task?.price ?? "",CUSTOM_COMPLETETIME:timestamp,CUSTOM_TASKID:model.Task?.taskId ?? ""])
//                        }
//                    })
//                }
//                self.view.addSubview(pubTaskView!)
//                self.toolbar.isHidden = true
//            }
        }else if tag == 0{
       
//            let vc = TaskListContainerViewController()
//            vc.currentChatRoomID = self.currentChatRoomID
//            vc._scrollToIndex = .all
            let vc = CommunityHelpViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if tag == 2{
            let vc = AppointmentListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}


