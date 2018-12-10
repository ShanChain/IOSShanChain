//
//  MyCardDetailsViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/10.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

private let H_cell = "AppointmentCardDetialsCell"

class MyCardDetailsViewController: SCBaseVC {

    
    @IBOutlet var tableHeaderView: UIView!
    
    @IBOutlet weak var header_icon: UIImageView!
    
    @IBOutlet weak var header_nikeNameLb: UILabel!
    
    @IBOutlet weak var header_cardLb: UILabel!
    

    @IBOutlet weak var header_priceLb: UILabel!
    
    
    @IBOutlet weak var header_totalLb: UILabel!
    
    
    @IBOutlet weak var header_releaseTimeLb: UILabel!
    
    
    @IBOutlet weak var header_ruleLb: UILabel!
    
    @IBOutlet weak var deadlineLb: UILabel!
    
    @IBOutlet weak var header_waitLb: UILabel!
    
    
    @IBOutlet weak var header_completeLb: UILabel!
    
    
    @IBOutlet weak var header_laveLB: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
      //  tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 50
        tableView.tableHeaderView = tableHeaderView
        tableView.register(UINib.init(nibName: H_cell, bundle: nil), forCellReuseIdentifier: H_cell)
        title = "马甲劵详情"
    }

}


extension MyCardDetailsViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: H_cell, for: indexPath) as! AppointmentCardDetialsCell
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        guard let cell = cell as? AppointmentListCell else {
    //            return
    //        }
    //    }
    
}

