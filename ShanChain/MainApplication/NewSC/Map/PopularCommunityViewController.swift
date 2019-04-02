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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "热门元社区"
        tableView.rowHeight = 250
        tableView.backgroundColor = SC_ThemeBackgroundViewColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib.init(nibName: k_cellID, bundle: nil), forCellReuseIdentifier: k_cellID)
        _requstData(false) {}
        self.addRightBarButtonItem(withTarget: self, sel: #selector(_earthAction), image: UIImage.loadDefaultImage("sc_Earth"), selectedImage: UIImage.loadDefaultImage("sc_Earth"))
        
        let leftImageName = SCCacheTool.shareInstance().characterModel.characterInfo.headImg
        self.addLeftBarButtonItem(withTarget: self, sel: #selector(_maskAnimationFromLeft), imageName: leftImageName, selectedImageName: leftImageName)
        
        // 抽屉
        self.cw_registerShowIntractive(withEdgeGesture: false) { (direction) in
            if direction == CWDrawerTransitionDirection.fromLeft{
                self._maskAnimationFromLeft()
            }
        }
    }
    
    func _earthAction(){
        let vc = BMKTestLocationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func _maskAnimationFromLeft(){
        let vc = LeftViewController()
        self.cw_showDrawerViewController(vc, animationType: CWDrawerAnimationType.mask, configuration: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @objc fileprivate func _requstData(_ isLoad:Bool  , _ complete: @escaping () -> ()) {
        
        SCNetwork.shareInstance().hh_Get(withUrl: HotChatRoom_URL, parameters: [:], showLoading: true) { (baseModel, error) in
            if error != nil{
                return
            }
            
            let data = baseModel?.data as! [Any]
            if data.count  == 0{
                 self.noDataTipShow(self.tableView, content:NSLocalizedString("sc_Nodata", comment: "字符串"), image: UIImage.loadImage("sc_com_icon_blankPage"), backgroundColor: SC_ThemeBackgroundViewColor)
                self.dataList = []
                self.tableView.reloadData()
                return;
            }
            if let datas:[HotCommunityModel] = [HotCommunityModel].deserialize(from: data) as? [HotCommunityModel]{
                self.dataList = datas
                self.tableView.reloadData()
            }
            
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
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
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
    }
    
}

extension PopularCommunityViewController:HotCommunityCellProtocol{
    func joinChatRoomFor(index: Int) {
        let hotModel = self.dataList[index]
        JGUserLoginService.jg_enterchatRoom(roomId: hotModel.roomId!) { (conversation , error) in
            if error == nil && conversation != nil{
                let chatRoomVC:HHChatRoomViewController = HHChatRoomViewController.init(conversation: conversation!, isJoinChat: false, navTitle: hotModel.roomName!)
                chatRoomVC.takeImage = UIImage.init(fromURLString: hotModel.thumbnails)
                chatRoomVC.shareTakeUrl = hotModel.thumbnails
                self.pushPage(chatRoomVC, animated: true)
            }
        }
    }
}

