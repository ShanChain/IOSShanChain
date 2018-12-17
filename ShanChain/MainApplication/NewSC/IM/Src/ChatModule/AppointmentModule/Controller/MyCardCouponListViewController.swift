//
//  MyCardCouponListViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/7.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit


private let H_cell = "AppointmentListCell"

class MyCardCouponListViewController: SCBaseVC {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    public required init(type:MyCardCouponType){
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var page:Int = 0
    let size:String = "10"
    fileprivate var type:MyCardCouponType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的马甲劵"
        tableView.estimatedRowHeight = 163
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib.init(nibName: H_cell, bundle: nil), forCellReuseIdentifier: H_cell)
        view.backgroundColor = SC_ThemeBackgroundViewColor
        tableView.backgroundColor = SC_ThemeBackgroundViewColor

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MyCardCouponListViewController:UITableViewDataSource,UITableViewDelegate{
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.type == .receive {
            let storyboard = UIStoryboard(name: "MyCardReceiveDetailsViewController", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ReceiveCardID") as? MyCardReceiveDetailsViewController
            pushPage(vc, animated: true)
            
        }else{
            let vc = MyCardDetailsViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
