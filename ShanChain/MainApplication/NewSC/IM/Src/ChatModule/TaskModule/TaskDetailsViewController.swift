//
//  TaskDetailsViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/8.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class TaskDetailsViewController: SCBaseVC {

    @IBOutlet var tableHeaderView: UIView!
    
    @IBOutlet weak var headerIcon: UIImageView!
    
    @IBOutlet weak var headerDateLb: UILabel!
    
    @IBOutlet weak var headerNameLb: UILabel!
    
    @IBOutlet weak var headerRewardLb: UILabel!
    
    @IBOutlet weak var headerContentLb: UILabel!
    
    
    @IBOutlet weak var headerDeadlineLb: UILabel!
    
    
    @IBOutlet weak var taskTriggerBtn: UIButton!
    
    
    @IBOutlet weak var headerCommentBtn: UIButton!
    
    
    @IBOutlet weak var headerCollectionBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableHeaderView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(tableView.width), height: CGFloat(300))
        tableView.tableHeaderView = tableHeaderView
        tableView.register(UINib.init(nibName: H_cellID, bundle: nil), forCellReuseIdentifier: H_cellID)
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    
    required init(taskID:String) {
        self.taskID = taskID
        super.init(nibName: "TaskDetailsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let H_cellID = "TaskContentDetailsCell"
    var taskID:String
    
}

extension  TaskDetailsViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: H_cellID, for: indexPath) as! TaskContentDetailsCell
        return cell
    }
    
}


