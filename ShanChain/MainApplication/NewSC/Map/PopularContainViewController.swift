//
//  PopularContainViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/5/28.
//  Copyright © 2019 ShanChain. All rights reserved.
//

import UIKit
import LTScrollView

class PopularContainViewController: SCBaseVC {

    private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)
    
    private lazy var viewControllers: [UIViewController] = {
        return [PopularCommunityViewController(), PopularARSViewController()]
    }()
    
    private lazy var titles:[String] = {
        return [NSLocalizedString("热门元社区", comment: "字符串"),NSLocalizedString("ARS", comment: "字符串")]
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
        pageView.scrollToIndex(index: 0)
        return pageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = SCWebSocket.manager.openWebSocket()
        title = "与一半地球人共创社区"
        view.addSubview(pageView)
        
        pageView.didSelectIndexBlock = {(_, index) in
            print("pageView.didSelectIndexBlock", index)
        }
        
        self.addRightBarButtonItem(withTarget: self, sel: #selector(_earthAction), image: UIImage.loadDefaultImage("sc_EarthNew"), selectedImage: UIImage.loadDefaultImage("sc_EarthNew"))
        
        _updateAvatar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(_updateAvatar), name:  NSNotification.Name(rawValue: kUpdateAvatarSuccess), object: nil)
        // 抽屉
        self.cw_registerShowIntractive(withEdgeGesture: false) { (direction) in
            if direction == CWDrawerTransitionDirection.fromLeft{
                self._maskAnimationFromLeft()
            }
        }
    }
    

    // MARK: -...
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
}
