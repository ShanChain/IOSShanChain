//
//  AppointmentListViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/6.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit


private let H_cell = "AppointmentListCell"

class AppointmentListViewController: SCBaseVC {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var headView: UIView!
    
    @IBOutlet weak var createBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "马甲劵"
        tableView.tableHeaderView = headView
         tableView.tableHeaderView?.backgroundColor = SC_ThemeBackgroundViewColor
        tableView.estimatedRowHeight = 163
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib.init(nibName: H_cell, bundle: nil), forCellReuseIdentifier: H_cell)
        tableView.backgroundColor = SC_ThemeBackgroundViewColor
        self.addRightBarButtonItem(withTarget: self, sel: #selector(_clickMy), title: "我的", tintColor: .black)
        view.backgroundColor = SC_ThemeBackgroundViewColor
        headView.backgroundColor = SC_ThemeBackgroundViewColor
        navigationController?.navigationBar.barTintColor = kNavBlueColor
    }
    
    func _clickMy(){
        let vc = MyCardCouponContainerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func createAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AppointmentCreateCardViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateCardID") as? AppointmentCreateCardViewController
        pushPage(vc, animated: true)
    }
    
}

extension AppointmentListViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: H_cell, for: indexPath) as! AppointmentListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? AppointmentListCell else {
            return
        }
        let section:Int = indexPath.section
        if section % 2 == 0 {
            cell.bgIcon.image =  UIImage.init(name: "sc_com_icon_CardPackage_1")
            cell.nameLb.textColor = SC_EmphasisColor
            cell.nikeNameLb.textColor = SC_EmphasisColor
            cell.deadlineLb.textColor = SC_EmphasisColor
            cell.priceLb.textColor = SC_EmphasisColor
            cell.statusLb.textColor = .white
        }else{
            cell.bgIcon.image =  UIImage.init(name: "sc_com_icon_CardPackage")
            cell.nameLb.textColor = .white
            cell.nikeNameLb.textColor = .white
            cell.deadlineLb.textColor = .white
            cell.priceLb.textColor = .white
            cell.statusLb.textColor = SC_ThemeMainColor
        }
    }
    
}
