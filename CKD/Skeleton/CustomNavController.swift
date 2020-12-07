//
//  CustomNavController.swift
//  CKD
//
//  Created by casanube on 2020/12/4.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class CustomNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: "#030303".toUIColor(),
                                             NSAttributedString.Key.font : PingFang(size: 17)]
        navigationBar.tintColor = Color3
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
