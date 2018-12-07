//
//  AppointmentCreateCardViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/6.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class AppointmentCreateCardViewController: UITableViewController {
    
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var nameFid: UITextField!
    
    @IBOutlet weak var cardFid: UITextField!
    
    
    @IBOutlet weak var priceFid: UITextField!
    
    @IBOutlet weak var numberFid: UITextField!
    
    @IBOutlet weak var failureTimeFid: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    private var timestamp = Date().timeStamp
    
    // 点击示例
    @IBAction func exampleAction(_ sender: UIButton) {
    }
    
    // 充值
    @IBAction func addMoneyAction(_ sender: UIButton) {
    }
    
    
    @IBAction func createAction(_ sender: UIButton) {
        if _verification() {
            
            
        }
    }
    
    @IBAction func clickIcon(_ sender: UITapGestureRecognizer) {
        DUX_UploadUserIcon.shareUploadImage().showActionSheet(inFatherViewController: self, imageTag: 0, delegate: self as DUX_UploadUserIconDelegate)
      
    }
    
    
    @IBAction func selectTimeAtion(_ sender: UITapGestureRecognizer) {
        let datePicker = YLDatePicker(currentDate: Date(), minLimitDate:MCDate.init(date: Date()).byAddDays(1).date, maxLimitDate: MCDate.init(date: Date()).byAddYears(20).date, datePickerType: .YMDHm) { [weak self] (date) in
            self?.failureTimeFid.text = date.getString(format: "YYYY-MM-dd HH:mm")
            self?.view.endEditing(true)
            self?.timestamp = String(Int(date.timeIntervalSince1970*1000))
        }
        datePicker.show()
    }
    
    func _verification() -> Bool {
        if (self.nameFid.text?.isEmpty)!{
            HHTool.showError("请输入名称")
            return false
        }
        if (self.cardFid.text?.isEmpty)!{
            HHTool.showError("请输入代号")
            return false
        }
        
        if (self.priceFid.text?.isEmpty)!{
            HHTool.showError("请输入单价")
            return false
        }
        
        if (self.numberFid.text?.isEmpty)!{
            HHTool.showError("请输入发布数量")
            return false
        }
        
        if (self.failureTimeFid.text?.isEmpty)!{
            HHTool.showError("失效时间不能为空")
            return false
        }
        
        if (self.descriptionTextView.text?.isEmpty)!{
            HHTool.showError("说明不能为空")
            return false
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "创建马甲劵"
        descriptionTextView.placeholder = "请具体描述该劵的使用说明，如联系电话、地址、金额限制等"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func navigationShouldPopOnBackButton() -> Bool {
        var  isClose:Bool = false
        self.hrShowAlert(withTitle: nil, message: "放弃创建马甲吗？", buttonsTitles: ["返回","确认"]) { (_, index) in
            if index == 1{
                isClose = true
            }
        }
        return  isClose
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


extension AppointmentCreateCardViewController:DUX_UploadUserIconDelegate{
    
    func uploadImageToServer(with image: UIImage!, tag: Int) {
        icon.image = image
    }
    
}

