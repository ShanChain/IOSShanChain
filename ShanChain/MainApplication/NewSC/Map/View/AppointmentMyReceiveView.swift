//
//  AppointmentMyReceiveView.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/10.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

private let H_cell = "AppointmentCardDetialsCell"

class AppointmentMyReceiveView: UIView {

    
  fileprivate  let redPaper_URL = "/v1/2.0/redPaper/obtainList"
  fileprivate  let appReceive_URL = "/v1/2.0/redPaper/appReceive"
    var page:Int = 0
    let characterId:String = SCCacheTool.shareInstance().getCurrentCharacterId()
    let userId:String = SCCacheTool.shareInstance().getCurrentUser()
    var dataList:[RedPaperModel] = []
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // 领取福包
    @IBAction func receiveAction(_ sender: UIButton) {
        SCNetwork.shareInstance().hh_Get(withUrl: appReceive_URL, parameters: ["characterId":characterId,"userId":userId], showLoading: true) { (baseModel, error) in
            if error == nil{
                YYHud.showTip("领取成功 \n可在【钱包】中查看", duration: 2.0)
                self._removeFromSuperview()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.alphaComponentMake()
        contentView = loadViewFromNib()
        contentView.frame = frame
        addSubview(contentView)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(_removeFromSuperview))
        contentView.addGestureRecognizer(tap)
        tableView.rowHeight = 72
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: H_cell, bundle: nil), forCellReuseIdentifier: H_cell)
        reftreshData()
        tableView.mj_header.beginRefreshing()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func _removeFromSuperview(){
        self.removeFromSuperview()
    }

}

extension AppointmentMyReceiveView{
    
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
    
    
    @objc fileprivate func _requstData(_ isLoad:Bool  , _ complete: @escaping () -> ()) {
        SCNetwork.shareInstance().hh_Get(withUrl: redPaper_URL, parameters: _requstPrameter(isLoad), showLoading: false) { (baseModel, error) in
            if error != nil{
                return
            }
            let data = baseModel?.data as! Dictionary<String,Any>
            let arr = data["content"] as! NSArray
            if let datas:[RedPaperModel] = [RedPaperModel].deserialize(from: arr) as? [RedPaperModel]{
                if (datas.count > 0){
                    if(isLoad){
                        for content in datas{
                            self.dataList.append(content)
                        }
                        self.page += 1
                    }else{
                        self.dataList = datas
                    }
                    self.tableView.reloadData()
                }else{
                    if isLoad == false{
                        self.dataList.removeAll()
                    }
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                
            }
            
            complete()
        }
        
    }
    
    fileprivate func _requstPrameter(_ isLoad:Bool) -> Dictionary<String, Any> {
        let pageStr = isLoad ? "\(page+1)":"\(page)"
        return  ["characterId":characterId,"page":pageStr,"size":10,"userId":userId]
      
    }
    
}

extension AppointmentMyReceiveView:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList.count > 0 {
            return dataList.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: H_cell, for: indexPath) as! AppointmentCardDetialsCell
        let model = dataList[indexPath.row]
        cell.leftConstraint.constant = 10
        cell.statusLb.text = "￥ 2"
        cell.icon._sd_setImage(withURLString: model.imgUrl)
        cell.nikeNameLb.text = model.name
        cell.timeLb.text = "来自\(model.shareUserName!)的分享"
        cell.statusLb.attributedText = NSString.setAttrFirst("￥", color: .black, font: Font(12), secendString: model.amount!, color: .black, font: Font(20))
        return cell
    }
}

