//
//  TaskListContainerViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/2.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit
import LTScrollView

private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)

enum TaskListType:Int{
    case all = 0
    case my
}


class TaskListContainerViewController: SCBaseVC {

    // 兼容OC
    public var _oc_scrollToIndex = 1{
        willSet{
            if newValue ==  1{
                _scrollToIndex = .my
                statusCode = StatusCode.myAll
            }else{
                _scrollToIndex = .all
            }
        }
    }
    
    
    public var _oc_statusCode = 0{
        willSet{
            statusCode = StatusCode(rawValue: newValue)!
        }
    }
    
    var statusCode:StatusCode = StatusCode.myAll
    var currentChatRoomID:String? // 当前广场ID
    
    public var _scrollToIndex:TaskListType = .my
    private lazy var viewControllers: [UIViewController] = {
        let listVc = TaskListViewController(type: TaskListType.all)
        let myVc = TaskListViewController(type: TaskListType.my)
        myVc.statusCode = self.statusCode
        return [listVc, myVc]
    }()
   
    private lazy var titles:[String] = {
        return [NSLocalizedString("sc_Tasklist", comment: "字符串"),NSLocalizedString("sc_MyTask", comment: "字符串")]
    }()
    
    var isSelectMyTask:Bool = false
    
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.sliderWidth = CGFloat(SCREEN_WIDTH/2)
       // layout.titleMargin = 10.0
        // （屏幕宽度 - 标题总宽度 - 标题间距宽度） / 2 = 最左边以及最右边剩余
        let lrMargin = (self.view.bounds.width - (CGFloat(self.titles.count) * layout.sliderWidth + CGFloat(self.titles.count - 1) * layout.titleMargin)) * 0.5
        layout.lrMargin = lrMargin
        layout.isAverage = true
        layout.titleSelectColor = kNavBlueColor
        layout.pageBottomLineColor = kNavBlueColor
        layout.bottomLineColor = kNavBlueColor;
        layout.sliderWidth = 100
        layout.titleViewBgColor = .white
        
        return layout
    }()
    
    private lazy var pageView: LTPageView = {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        let Y: CGFloat = statusBarH + 44
        let H: CGFloat = glt_iphoneX ? (self.view.bounds.height - Y - 34) : self.view.bounds.height - Y
        let pageView = LTPageView(frame: CGRect(x: 0, y: Y, width: self.view.bounds.width, height: H), currentViewController: self, viewControllers: self.viewControllers, titles: self.titles, layout: self.layout)
        pageView.isClickScrollAnimation = true
        pageView.scrollToIndex(index: self._scrollToIndex.rawValue)
        return pageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("sc_RewardTask", comment: "字符串")
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(pageView)
        pageView.didSelectIndexBlock = {(_, index) in
            print("pageView.didSelectIndexBlock", index)
        }
        
        self.addRightBarButtonItem(withTarget: self, sel: #selector(_publish), title: NSLocalizedString("sc_post", comment: "字符串"), tintColor: .black)
    }
    
    func _publish() {
        
        for view in self.view.subviews{
            if view.tag == 6666{
                return
            }
        }
        
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
                let params:Dictionary =  ["bounty":reward,"currency":"rmb","dataString":dataString,"roomId":self?.currentChatRoomID ?? SCCacheTool.shareInstance().chatRoomId!,"time":timestamp,"characterId":characterId,"authCode":authCode] as [String : Any]
                // 添加任务
                HHTool.showChrysanthemum()
                SCNetwork.shareInstance().v1_post(withUrl: TASK_ADD_URL, params: params, showLoading: true, call: { (baseModel, error) in
                    HHTool.dismiss()
                    if((error) != nil){
                        HHTool .showError(NSLocalizedString("sc_helpFailed", comment: "字符串"))
                        return
                    }
                     HHTool .showSucess(NSLocalizedString("sc_helpAccomplished", comment: "字符串"))
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPublishTaskSuccess), object: nil)
                })
            }
            self.view.addSubview(pubTaskView!)
        }
    }
    
}


