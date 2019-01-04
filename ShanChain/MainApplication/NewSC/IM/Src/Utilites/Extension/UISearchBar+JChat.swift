//
//  UISearchBar+JChat.swift
//  JChat
//
//  Created by 邓永豪 on 2017/10/13.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

extension UISearchBar {
    static var `default`: UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = NSLocalizedString("sc_IM_search", comment: "字符串")
        searchBar.barStyle = .default
        searchBar.backgroundColor = .white
        searchBar.barTintColor = .white
        searchBar.autocapitalizationType = .none
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.layer.masksToBounds = true
        return searchBar
    }
}
