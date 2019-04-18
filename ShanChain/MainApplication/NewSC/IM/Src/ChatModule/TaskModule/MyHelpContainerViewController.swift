//
//  MyHelpContainerViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/2.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit
import LTScrollView

private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)

enum HelpType:Int{
    case HelpedMe = 0 // 帮过我的
    case I_helped  //我帮过的
}

class MyHelpContainerViewController: SCBaseVC {

    // 兼容OC
    @objc public var _oc_scrollToIndex = 1{
        willSet{
            if newValue ==  1{
                _scrollToIndex = .I_helped
            }else{
                _scrollToIndex = .HelpedMe
            }
        }
    }
    
    var currentChatRoomID:String? // 当前广场ID
    
    public var _scrollToIndex:HelpType = .HelpedMe
    private lazy var viewControllers: [UIViewController] = {
        let helpMeVC = MyHelpListViewController(statusCode: StatusCode.myPublish)
        let myHelpedVC = MyHelpListViewController(statusCode: StatusCode.myReceive)
        return [helpMeVC, myHelpedVC]
    }()
    
    private lazy var titles:[String] = {
        return [NSLocalizedString("sc_MyPost", comment: "字符串"),NSLocalizedString("sc_MyHelped", comment: "字符串")]
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
