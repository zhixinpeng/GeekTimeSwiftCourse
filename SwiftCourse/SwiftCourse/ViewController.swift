//
//  ViewController.swift
//  SwiftCourse
//
//  Created by 彭智鑫 on 2022/8/8.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = HomeViewController()
        home.tabBarItem.image = R.image.home()
        home.tabBarItem.selectedImage = R.image.home_selected()
        home.tabBarItem.title = "首页"
        let navigationHome = UINavigationController(rootViewController: home)
        addChild(navigationHome)
        
        let mine = MineViewController()
        mine.tabBarItem.image = R.image.mine()
        mine.tabBarItem.selectedImage = R.image.mine_selected()
        mine.tabBarItem.title = "我的"
        let navigationMine = UINavigationController(rootViewController: mine)
        addChild(navigationMine)
    }
}

