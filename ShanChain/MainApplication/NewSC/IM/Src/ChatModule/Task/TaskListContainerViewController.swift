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

class TaskListContainerViewController: UIViewController {


    private lazy var viewControllers: [UIViewController] = {
        let listVc = TaskListViewController()
        let myVc = TaskListViewController()
        return [listVc, myVc]
    }()
   
    private lazy var titles:[String] = {
        return ["任务列表","我的任务"]
    }()
    
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
        
        return layout
    }()
    
    private lazy var pageView: LTPageView = {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        let Y: CGFloat = statusBarH + 44
        let H: CGFloat = glt_iphoneX ? (self.view.bounds.height - Y - 34) : self.view.bounds.height - Y
        let pageView = LTPageView(frame: CGRect(x: 0, y: Y, width: self.view.bounds.width, height: H), currentViewController: self, viewControllers: self.viewControllers, titles: self.titles, layout: self.layout)
        pageView.isClickScrollAnimation = true
        return pageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(pageView)
        navigationController?.navigationBar.barTintColor = kNavBlueColor
        addRightBarButtonItem(withTarget: self, sel: #selector(_add), image: UIImage.loadImage("sc_com_icon_whiteAdd"), selectedImage: UIImage.loadImage("sc_com_icon_whiteAdd"))
        //        simpleManagerConfig()
        
        pageView.didSelectIndexBlock = {(_, index) in
            print("pageView.didSelectIndexBlock", index)
        }
    }
    
    func _add() {
        
    }
    
}


