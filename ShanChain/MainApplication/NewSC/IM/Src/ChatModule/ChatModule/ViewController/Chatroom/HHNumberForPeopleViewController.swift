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
    fileprivate var roomId:String!
    fileprivate var page:Int = 0
    fileprivate var size:Int = 10
    
    fileprivate var dataList:[PeopleListModel] = []
    fileprivate var users:[JMSGUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "广场成员"
        tableView.register(UINib.init(nibName: H_Peoplecell, bundle: nil), forCellReuseIdentifier: H_Peoplecell)
        tableView.rowHeight = 65
        tableView.tableFooterView = UIView()
        reftreshData()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        _requstData(false) {}
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
    
    fileprivate func _requstPrameter(_ isLoad:Bool) -> Dictionary<String, Any> {
        let pageStr = isLoad ? "\(page+1)":"\(page)"
        return ["count":"\(count)","roomId":roomId,"page":pageStr,"size":"\(size)"]
    }
    
    
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
    
    fileprivate func _requstData(_ isLoad:Bool  , _ complete: @escaping () -> ()){
        SCNetwork.shareInstance().v1_post(withUrl: JM_RoomMembers_URL, params: self._requstPrameter(isLoad), showLoading: true) { (baseModel, error) in
            if ((error) != nil){
                return
            }
            let dic = baseModel?.data as!Dictionary<String, Any>
            let data = dic["content"] as! NSArray
            if data.count > 0 {
                if let arr = [PeopleListModel].deserialize(from: data) as? [PeopleListModel]{
                    if isLoad {
                        for people in arr{
                            self.dataList.append(people)
                        }
                        self.page += 1
                    }else{
                        self.dataList = arr
                    }
                    
                    var userNameArray:[String] = []
                    for  list in  self.dataList{
                        userNameArray.append(list.username!)
                    }
                    HHTool.showChrysanthemum()
                    JMSGUser.userInfoArray(withUsernameArray: userNameArray, completionHandler: { (result, error) in
                        HHTool.dismiss()
                        if (error) == nil {
                            self.users = result as! [JMSGUser]
                            for (index,people) in (self.dataList.enumerated()){
                                if index >= self.users.count{
                                    break
                                }
                                self.users[index].thumbAvatarData({ (data, userName, error) in
                                    if data != nil{
                                        let img = UIImage.init(data: data!)
                                        people.iconImage = img!
                                         self.tableView.reloadData()
                                    }
//                                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                                })
                                people.user = self.users[index]
                                people.nickname = self.users[index].nickname
                               
                            }
                             self.tableView.reloadData()
                        }
                    })
                }
                 complete()
            }else{
                if isLoad == false{
                    self.dataList.removeAll()
                    complete()
                }
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
               
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
