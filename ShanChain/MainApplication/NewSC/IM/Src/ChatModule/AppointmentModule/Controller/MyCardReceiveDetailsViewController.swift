//
//  MyCardReceiveDetailsViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/11.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

enum CouponsStatus:Int{
    
    case create_Wait = 0 // 创建方待核销
    case create_Complete  // 创建方已核销
    case create_Invalid // 创建方已失效
    
    case receive_Un = 10    //领取方未领取
    case receive_Wait       // 领取方待使用
    case receive_Complete   // 领取方已使用
    case receive_Invalid // 创建方已失效
}

class MyCardReceiveDetailsViewController: UITableViewController {

    @IBOutlet weak var icon: UIImageView!
    
    
    @IBOutlet weak var userNameLb: UILabel!
    
    
    @IBOutlet weak var priceLb: UILabel!
    
    
    @IBOutlet weak var titleLb: UILabel!
    
    
    @IBOutlet weak var cardLb: UILabel!
    
    
    @IBOutlet weak var ruleLb: UILabel!
    
    
    @IBOutlet weak var dealTimeLb: UILabel!
    
    let status:CouponsStatus = .receive_Wait
    
    var couponsId:String = ""
    
    @IBAction func applyAction(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   title = "马甲劵详情"
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setImage(UIImage(named: "sc_com_icon_back"), for: .normal)
        button.addTarget(self, action: #selector(_back), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func _back(){
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
