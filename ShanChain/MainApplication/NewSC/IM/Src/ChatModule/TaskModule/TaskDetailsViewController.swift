//
//  TaskDetailsViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/8.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class TaskDetailsViewController: SCBaseVC {

    @IBOutlet var tableHeaderView: UIView!
    
    @IBOutlet weak var headerIcon: UIImageView!
    
    @IBOutlet weak var headerDateLb: UILabel!
    
    @IBOutlet weak var headerNameLb: UILabel!
    
    @IBOutlet weak var headerRewardLb: UILabel!
    
    @IBOutlet weak var headerContentLb: UILabel!
    
    
    @IBOutlet weak var headerDeadlineLb: UILabel!
    
    
    @IBOutlet weak var taskTriggerBtn: UIButton!
    
    
    @IBOutlet weak var headerCommentBtn: UIButton!
    
    
    @IBOutlet weak var headerLikeBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet var bottomSendView: UIView!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    
    @IBOutlet weak var sendTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "任务详情"
        layoutUI()
        reftreshData()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HHTool.showChrysanthemum()
        self._requstData(false) {
             HHTool.dismiss()
        }
        self.requstTaskDetailsData {}
    }
    
    override func layoutUI() {
        let height = headerContentLb.text?.heightForAdaptive(Font:headerContentLb.font , view.width - 130)
        tableHeaderView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(tableView.width), height: CGFloat(240 + height!))
        bottomSendView.frame = CGRect(x: 0, y: view.height - 300, width: view.width, height: 300)
        tableView.tableHeaderView = tableHeaderView
        view.addSubview(bottomSendView)
        bottomSendView.isHidden = true
        tableView.register(UINib.init(nibName: H_cellID, bundle: nil), forCellReuseIdentifier: H_cellID)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.tableFooterView = UIView()
        glt_scrollView = tableView
        
        sendBtn.cornerRadius = sendBtn.height/2.0
        sendBtn.borderColor = _ThemeMainColor()
        sendBtn.borderWidth = 1.0
        
        headerIcon._setCornerRadiusCircle()
        
        headerDeadlineLb.text = self.time
        headerContentLb.text = self.taskContent
        headerRewardLb.text = self.reward
        sendTextView.delegate = self
        
    }
    
    required init(taskID:String,content:String,reward:String,time:String) {
        self.taskID = taskID
        self.taskContent = content
        self.time = time
        self.reward = reward
        super.init(nibName: "TaskDetailsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let H_cellID = "TaskContentDetailsCell"
    let characterId:String = SCCacheTool.shareInstance().getCurrentCharacterId()
    var taskID:String
    var taskContent:String
    var time:String // 截止时间
    var reward:String
    var page:Int = 0
    let size:String = "10"
    var backgroundView:UIView?
    var dataModel:TaskCommentListModel?
    var taskDetailsModel:TaskDetailsModel?
    var contentList:[TaskCommentListModel_content] = []
    
    @IBAction func commentAction(_ sender: UIButton) {
        bottomSendView.isHidden = false
        sendTextView.becomeFirstResponder()
//        backgroundView = UIView(frame: CGRect(x: 0, y:0, width: view.width, height: bottomSendView.y))
//        view.addSubview(backgroundView!)
    }
    
    // 任务点赞
    @IBAction func likeAction(_ sender: UIButton) {
        SCNetwork.shareInstance().v1_post(withUrl: TASK_SUPPORT_URL, params:_taskSupportPrameter(), showLoading: true) { [weak self] (baseModel, error) in
            if (error != nil){
                return
            }
            self?.page = 0
            self?._requstData(false, {})
        }
    }
    
    // 领取任务
    
    @IBAction func receiveTaskAction(_ sender: UIButton) {
        SCNetwork.shareInstance().v1_post(withUrl: TASK_RECEIVE_URL, params: _receiveTaskPrameter(), showLoading: true) { (baseModel, error) in
            if (error != nil){
                return
            }
            self.requstTaskDetailsData {}
            let dict = baseModel?.data as! Dictionary<String,Any>
            if let model = TaskRecieveSuccessModel.deserialize(from: dict){
                let successView:RecieveTaskView = RecieveTaskView(recieTaskModel: model, frame: self.view.frame)
            }
            
            
        }
    }
    
    @IBAction func hiddenTextView(_ sender: Any) {
         _recover()
    }
    
    func _recover(){
        bottomSendView.isHidden = true
        sendTextView.resignFirstResponder()
        view.endEditing(true)
    }
    
    
    func _configurationDetailsUI(){
        headerDeadlineLb.text = "完成时限: \(NSDate.chatingTime(taskDetailsModel!.expiryTime) ?? "")"
        headerContentLb.text =  taskDetailsModel!.intro
        headerRewardLb.text = "赏金 ￥\(taskDetailsModel!.bounty ?? "")"
        headerIcon._sd_setImage(withURLString: taskDetailsModel?.headImg)
        headerNameLb.text = taskDetailsModel!.name
        headerLikeBtn.setTitle(taskDetailsModel!.supportCount, for: .normal)
        headerCommentBtn.setTitle(taskDetailsModel!.commentCount, for: .normal)
        taskTriggerBtn.setTitle(taskDetailsModel?.receiveBtnTitle(), for: .normal)
        if (taskDetailsModel?.isReceive() == true) {
            taskTriggerBtn.setTitleColor(.gray, for: .normal)
            taskTriggerBtn.borderWidth = 0.01
            taskTriggerBtn.isUserInteractionEnabled = false
        }else{
            taskTriggerBtn.borderWidth = 1
            taskTriggerBtn.setTitleColor(SC_ThemeMainColor, for: .normal)
        }
    }
    
    @IBAction func sendTaskCommentAction(_ sender: UIButton) {
        SCNetwork.shareInstance().v1_post(withUrl: TASKCOMMENT_ADD_URL, params: _commentAddTaskPrameter(), showLoading: true) { [weak self] (baseModel, error) in
            if (error != nil){
                return
            }
            self?._recover()
            self?.page = 0
            self?._requstData(false, {})
        }
        
    }
    
}


extension TaskDetailsViewController{
    
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
    
    
    func requstTaskDetailsData(_ complete: @escaping () -> ()){
        SCNetwork.shareInstance().v1_post(withUrl: TASK_DETAILS_URL, params: ["taskId":self.taskID], showLoading: false) { (baseModel, error) in
            if (error != nil){
                return
            }
            let dict = baseModel?.data as! Dictionary<String,Any>
            if let model = TaskDetailsModel.deserialize(from: dict){
                self.taskDetailsModel = model
                self._configurationDetailsUI()
                self.tableView.reloadData()
            }
            
        }
    }
    
    
   fileprivate func _requstData(_ isLoad:Bool  , _ complete: @escaping () -> ()) {
    
        SCNetwork.shareInstance().v1_post(withUrl: TASKCOMMENT_URL, params: _requstPrameter(isLoad), showLoading: true) { (baseModel, error) in
             complete()
            if (error != nil){
                return
            }
            
            let dict = baseModel?.data as! Dictionary<String, Any>
            if let model = TaskCommentListModel.deserialize(from: dict){
                self.dataModel = model
                if (model.content!.count > 0){
                    if(isLoad){
                        for content in model.content!{
                            self.contentList.append(content)
                        }
                        self.page += 1
                    }else{
                        self.contentList = model.content!
                    }
                   
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    // 请求评论列表
   fileprivate  func _requstPrameter(_ isLoad:Bool) -> Dictionary<String, Any> {
        let pageStr = isLoad ? "\(page+1)":"\(page)"
        return ["characterId":characterId,"page":pageStr,"size":size,"taskId":self.taskID]
    }
    
    // 添加评论
    fileprivate func _commentAddTaskPrameter() ->  Dictionary<String, Any>{
        return ["characterId":characterId,"dataString":sendTextView.text,"taskId":self.taskID]
    }
    
    // 点赞任务
    fileprivate func _taskSupportPrameter() ->  Dictionary<String, Any> {
        return ["characterId":characterId,"taskId":self.taskID]
    }
    // 点赞评论or取消评论点赞
    fileprivate func _taskCommentLikePrameter(idx:Int) -> Dictionary<String, Any> {
        return ["characterId":characterId,"commentId":self.contentList[idx].commentId ?? ""]
    }
    // 领取任务
    fileprivate func _receiveTaskPrameter() -> Dictionary<String, Any> {
        return ["characterId":characterId,"roomId":self.taskDetailsModel?.roomId ?? "","taskId":self.taskID]
    }
    
}


extension  TaskDetailsViewController:UITableViewDataSource,UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: H_cellID, for: indexPath) as! TaskContentDetailsCell
        let  content = self.contentList[indexPath.row]
        cell.contentLb.text = content.content
        cell.timeLb.text = NSDate.chatingTime(content.createTime)
        cell.icon._setCornerRadiusCircle()
        cell.likeBtn.isSelected = content.mySupport
        cell.likeBtn.setTitle(content.supportCount, for: .normal)
        cell.likeBtn.tag = indexPath.row
        cell.likeBlock = { [weak self] (idx)  in
            SCNetwork.shareInstance().v1_post(withUrl: content.mySupport ? TASK_COMMENT_SUPPORT_REMOVE_URL:TASK_COMMENT_SUPPORT_URL, params: self?._taskCommentLikePrameter(idx: idx), showLoading: true, call: { (baseModel, error) in
                if(error == nil){
                    self?._requstData(false, {})
                }
            })
            
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        guard let cell = cell as? TaskContentDetailsCell else {
//            return
//        }
//      
//       
//    }
    
}

extension  TaskDetailsViewController:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            bottomSendView.isHidden = true
            sendTextView.resignFirstResponder()
            view.endEditing(true)
            
            return false
        }
        
        return true
    }
    
}


