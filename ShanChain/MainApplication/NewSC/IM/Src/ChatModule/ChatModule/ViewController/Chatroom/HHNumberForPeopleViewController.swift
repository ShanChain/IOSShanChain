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
    fileprivate var dataList:[PeopleListModel] = []
    fileprivate var users:[JMSGUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "广场成员"
        tableView.register(UINib.init(nibName: H_Peoplecell, bundle: nil), forCellReuseIdentifier: H_Peoplecell)
        tableView.rowHeight = 65
        tableView.tableFooterView = UIView()
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
        SCNetwork.shareInstance().v1_post(withUrl: JM_RoomMembers_URL, params: ["count":"\(count)","roomId":roomId], showLoading: true) { (baseModel, error) in
            if ((error) != nil){
                return
            }
             let data = baseModel?.data as! NSArray
             if data.count > 0 {
                if let arr = [PeopleListModel].deserialize(from: data) as? [PeopleListModel]{
                     self.dataList = arr
                    var userNameArray:[String] = []
                    for  list in arr{
                        userNameArray.append(list.username!)
                    }
                    JMSGUser.userInfoArray(withUsernameArray: userNameArray, completionHandler: { (result, error) in
                        if (error) == nil {
                            self.users = result as! [JMSGUser]
                            for (index,people) in (self.dataList.enumerated()){
                                self.users[index].thumbAvatarData({ (data, userName, error) in
                                    if data != nil{
                                        let img = UIImage.init(data: data!)
                                        people.iconImage = img!
                                    }
                                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                                })
                                 people.user = self.users[index]
                                 people.nickname = self.users[index].nickname
                            }
                            self.tableView.reloadData()
                        }
                    })                    
                }
            }
        }
    }
    
}

extension HHNumberForPeopleViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList.count > 0 {
            return  dataList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: H_Peoplecell, for: indexPath) as! HHNumberPeopleListCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HHNumberPeopleListCell else{
            return
        }
        let people = dataList[indexPath.row]
        cell.nikeNameLb.text = people.nickname
        cell.icon.image = people.iconImage
        cell.dialogueBtn.tag = indexPath.row
        cell.selectionStyle = .none
    }
}

extension HHNumberForPeopleViewController:HHNumberPeopleListCellProtocol{
    
    func clickDialogueForChat(index: Int) {
        let people = dataList[index]
        let vc = JCUserInfoViewController()
        vc.user = people.user
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
