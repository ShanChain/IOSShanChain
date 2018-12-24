//
//  PopularCommunityViewController.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/18.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit


fileprivate  let  k_cellID  = "HotCommunityCell"

class PopularCommunityViewController: SCBaseVC {

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "热门元社区"
        tableView.rowHeight = 250
        tableView.backgroundColor = SC_ThemeBackgroundViewColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib.init(nibName: k_cellID, bundle: nil), forCellReuseIdentifier: k_cellID)
        
        let fib = generateFibonaccis(10)
        print(fib.map({"\($0)"}).joined(separator: " "))
    }
    
    
    func generateFibonaccis(_ n: Int) -> [Int] {
        var fib = Array(repeating: 1, count: n)
        for i in 2..<n {
            fib[i] = fib[i - 2] + fib[i - 1]
        }
        return fib
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension PopularCommunityViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: k_cellID, for: indexPath) as! HotCommunityCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HotCommunityCell else {
            return
        }
        cell.selectionStyle = .none
    }
    
}
