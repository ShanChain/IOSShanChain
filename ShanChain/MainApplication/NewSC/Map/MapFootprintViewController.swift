//
//  MapFootprintViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/6.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit


enum ControllerType:Int{
    case footprint
    case collection
}


class MapFootprintViewController: SCBaseVC {
    

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate  let  k_cellID  = "MapFootprintCell"
    
    fileprivate var type:ControllerType = .footprint

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150
        tableView.register(UINib.init(nibName: k_cellID, bundle: nil), forCellReuseIdentifier: k_cellID)
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
     public required init(type:Int){
        self.type = ControllerType.init(rawValue: type)!
        super.init(nibName:"MapFootprintViewController" , bundle: nil)
        switch self.type {
        case .footprint:
            title = "足迹"
        case .collection:
            title = "收藏夹"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapFootprintViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: k_cellID, for: indexPath) as! MapFootprintCell
        return cell
    }
    
}
