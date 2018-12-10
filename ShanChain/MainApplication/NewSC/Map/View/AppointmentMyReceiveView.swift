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

 
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func receiveAction(_ sender: UIButton) {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.alphaComponentMake()
        contentView = loadViewFromNib()
        addSubview(contentView)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(_removeFromSuperview))
        contentView.addGestureRecognizer(tap)
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: H_cell, bundle: nil), forCellReuseIdentifier: H_cell)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func _removeFromSuperview(){
        self.removeFromSuperview()
    }

}
extension AppointmentMyReceiveView:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: H_cell, for: indexPath) as! AppointmentCardDetialsCell
        cell.leftConstraint.constant = 10
        cell.statusLb.text = "￥ 2"
        return cell
    }
}

