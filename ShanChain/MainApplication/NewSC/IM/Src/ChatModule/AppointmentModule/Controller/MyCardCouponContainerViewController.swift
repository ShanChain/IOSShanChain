//
//  MyCardCouponContainerViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/7.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit
import LTScrollView

private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)

enum MyCardCouponType:Int{
    case receive = 0
    case create
}

class MyCardCouponContainerViewController: SCBaseVC {
    
    public var _scrollToIndex:MyCardCouponType = .receive
    // 兼容OC
    public var _oc_scrollToIndex = 1{
        willSet{
            if newValue ==  1{
                _scrollToIndex = .receive
            }else{
                _scrollToIndex = .create
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("sc_Voucher_MyVoucher", comment: "字符串")
        view.backgroundColor = SC_ThemeBackgroundViewColor
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(pageView)
        pageView.didSelectIndexBlock = {(_, index) in
            print("pageView.didSelectIndexBlock", index)
        }
//        self.addNavigationRight(withImageName: "sc_com_icon_ScanCode", withTarget: self, withAction: #selector(_scanCode))
        self.addRightBarButtonItem(withTarget: self, sel: #selector(_scanCode), image: UIImage.loadDefaultImage("sc_com_icon_ScanCode"), selectedImage: UIImage.loadDefaultImage("sc_com_icon_ScanCode"))
        // Do any additional setup after loading the view.
    }
    
    // 扫码二维码
    func _scanCode(){
       ScanCodeService.newInstancetype(withPush: self)
    }
    
    private lazy var titles:[String] = {
        return [NSLocalizedString("sc_Voucher_Igot", comment: "字符串"),NSLocalizedString("sc_Voucher_Icreated", comment: "字符串")]
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
    
    
    private lazy var viewControllers: [UIViewController] = {
        let receiveVc = MyCardCouponListViewController(type: MyCardCouponType.receive)
        let createVc = MyCardCouponListViewController(type: MyCardCouponType.create)
        return [receiveVc, createVc]
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

}
