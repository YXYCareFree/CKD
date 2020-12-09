//
//  CustomTabBarController.swift
//  CKD
//
//  Created by casanube on 2020/12/1.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setTabBarStyle()
        setUI()
    }
    
    func setTabBarStyle() {
        let item = UITabBarItem.appearance()
        
        item.setTitleTextAttributes([NSAttributedString.Key.font : PingFang(size: 10), NSAttributedString.Key.foregroundColor : "#8E8E93".toUIColor()], for: .normal)
        item.setTitleTextAttributes([NSAttributedString.Key.font : PingFang(size: 10), NSAttributedString.Key.foregroundColor : "#23BDC5".toUIColor()], for: .selected)
        
        UITabBar.appearance().tintColor = "#23BDC5".toUIColor()
        UITabBar.appearance().unselectedItemTintColor = "#8E8E93".toUIColor()
    }

    func setUI() {
            
        delegate = self
        setValue(CustomTabBar(), forKey: "tabBar")

        let home = CustomNavController.init(rootViewController: HomeViewController())
        home.setTabBar(title: "首页", norImg: "tabBar_home_nor", selImg: "tabBar_home_sel")
        
        let health = CustomNavController.init(rootViewController: HomeViewController());
        health.setTabBar(title: "健康", norImg: "tabBar_health_nor", selImg: "tabBar_health_sel")
      
        let find = CustomNavController.init(rootViewController: FindController())
        find.setTabBar(title: "发现", norImg: "tabBar_find_nor", selImg: "tabBar_find_sel")
       
        let tool = CustomNavController.init(rootViewController: HomeViewController())
        tool.setTabBar(title: "", norImg: "tabBar_center", selImg: "tabBar_center")
        
        let mine = CustomNavController.init(rootViewController: HomeViewController())
        mine.setTabBar(title: "我的", norImg: "tabBar_mine_nor", selImg: "tabBar_mine_sel")
                             
        viewControllers = [home, health, tool, find, mine]
    }
}

extension CustomTabBarController: UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.title == "" {
            let vc = FunctionController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
    

}
