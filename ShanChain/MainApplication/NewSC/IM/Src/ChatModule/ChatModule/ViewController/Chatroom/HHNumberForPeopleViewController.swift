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
    fileprivate var newUsers:[JMSGUser] = []
    
    lazy var item1 = UIBarButtonItem.init(title: "管理", style: .plain, target: self, action: #selector(self.clickRightBarDelete))
    lazy var item2 = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(self.clickRightBarCancel))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        self.title = "广场成员"
        tableView.register(UINib.init(nibName: H_Peoplecell, bundle: nil), forCellReuseIdentifier: H_Peoplecell)
        tableView.rowHeight = 65
        tableView.tableFooterView = UIView()
        //表格在编辑状态下允许多选
        tableView.allowsMultipleSelectionDuringEditing = true
        reftreshData()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)//这一句，修复偏移问题！
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false

            
        }
        _requstData(false) {}
        
        owner()
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
    private lazy var moreButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    
    func owner() {
        
        SCNetwork.shareInstance()?.hh_Get(withUrl: "/jm/room/ownerVerify", parameters: ["roomId":self.roomId,"token":SCCacheTool.shareInstance().getUserToken()], showLoading: false, call: { [unowned self] (result, err) in
            
            if let code = result?.code, let data = result?.data as? Int {
                if code == "000000" && data == 1 {
                    // 是创建者
                    
                    self.item1.tintColor = UIColor.init(r: 172, g: 129, b: 233)
                    self.item2.tintColor = UIColor.init(r: 172, g: 129, b: 233)
                    self.navigationItem.rightBarButtonItems = [self.item1]
                    
                }
            }
            
        })
    }
    
    @objc func clickRightBarDelete() {
        if tableView.isEditing {
            //删除
            if let selectCount = tableView.indexPathsForSelectedRows {
                print(selectCount,self.dataList[(selectCount.first?.row)!].username)
                
//                SCNetwork.shareInstance()?.v1_post(withUrl: "/jm/room/rmMembers", params: ["roomId":roomId,"jArray":], showLoading: true, call: { (model, err) in
//
//                })
            }
        }else {
            //管理
            let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            let action1 = UIAlertAction.init(title: "删除广场成员", style: .destructive) { (action) in
                self.tableView.setEditing(true, animated: true)
                self.item1.title = "删除"
                self.navigationItem.setRightBarButtonItems([self.item1,self.item2], animated: true)
            }
            let action2 = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
                self.tableView.setEditing(false, animated: true)
                self.navigationItem.setRightBarButtonItems([self.item1], animated: true)
            }
            alert.addAction(action1)
            alert.addAction(action2)
            self.present(alert, animated: true, completion: {})
            
        }
        
        
    }
    @objc func clickRightBarCancel() {
        //取消
        self.tableView.setEditing(false, animated: true)
        self.navigationItem.setRightBarButtonItems([self.item1], animated: true)
        self.item1.title = "管理"
    }
}

extension  HHNumberForPeopleViewController{
    
    fileprivate func _requstPrameter(_ isLoad:Bool) -> Dictionary<String, Any> {
//        let pageStr = isLoad ? "\(page+1)":"\(page)"
        return ["count":"\(count)","roomId":roomId,"page":self.page,"size":"\(size)"]
    }
    
    
    fileprivate func reftreshData()  {
        tableView.mj_footer = MJRefreshBackNormalFooter {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                print("上拉加载更多数据")
                self?.page += 1
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
        print(self._requstPrameter(isLoad))
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
//                        self.page += 1
                    }else{
                        self.dataList = []
                        self.dataList = arr
                    }
                    
                    var userNameArray:[String] = []
                    for  list in  self.dataList{
                        userNameArray.append(list.username!)
                    }
                    print(userNameArray)//这里的数据顺序是对的
//                    HHTool.showChrysanthemum()
                    JMSGUser.userInfoArray(withUsernameArray: userNameArray, completionHandler: { (result, error) in
//                        HHTool.dismiss()
                        if (error) == nil {
                            self.users = result as! [JMSGUser]
//                            print(self.users)//这里的数据顺序是错的
                            self.newUsers = []
                            for (index,people) in (self.dataList.enumerated()){
                                // 这里是处理列表排序错乱问题，这个问题出在 userInfoArray 函数的返回值本身就是乱序的，需要自己做匹配
                                for (_,user) in (self.users.enumerated()) {
                                    if (people.username == user.username) {
//                                        print(index,idx)
                                        self.newUsers.append(user)
                                    }
                                }
                                
                                if index >= self.users.count{
                                    break
                                }
                                self.newUsers[index].thumbAvatarData({ (data, userName, error) in
                                    if data != nil{
                                        let img = UIImage.init(data: data!)
                                        people.iconImage = img!
//                                         self.tableView.reloadData()
                                        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                                    }
                                    
                                })
                                people.user = self.newUsers[index]
                                people.nickname = self.newUsers[index].nickname
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
//        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if let selectCount = tableView.indexPathsForSelectedRows {
                self.item1.title = "删除\(selectCount.count)"
                
            }
        }else {
            do {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing {
            if let selectCount = tableView.indexPathsForSelectedRows {
                self.item1.title = "删除\(selectCount.count)"
                
            }else {
                
                self.item1.title = "删除"
            }
        }
        
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
