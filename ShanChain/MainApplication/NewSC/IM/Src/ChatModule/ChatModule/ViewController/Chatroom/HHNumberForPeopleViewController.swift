//
//  HHNumberForPeopleViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/28.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

private let H_Peoplecell = "HHNumberPeopleListCell"

class HHNumberForPeopleViewController: SCBaseVC {

    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var count:Int = 0 // 广场人数
    fileprivate var roomId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: H_Peoplecell, bundle: nil), forCellReuseIdentifier: H_Peoplecell)
        tableView.rowHeight = 65
        _requstData()
    }
    
    public required init(count:Int, roomId:String) {
        self.count = count
        self.roomId = roomId
        super.init(nibName: "HHNumberForPeopleViewController", bundle: nil) // 加载xib视图
        automaticallyAdjustsScrollViewInsets = false;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension  HHNumberForPeopleViewController{
    func _requstData(){
        SCNetwork.shareInstance().v1_post(withUrl: JM_RoomMembers_URL, params: ["count":"\(count)","roomId":roomId], showLoading: true) { (result, error) in
            
        }
    }
    
}

extension HHNumberForPeopleViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: H_Peoplecell, for: indexPath) as! HHNumberPeopleListCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

extension HHNumberForPeopleViewController:HHNumberPeopleListCellProtocol{
    
    func clickDialogueForChat(listModel: PeopleListModel) {
        
    }
}
