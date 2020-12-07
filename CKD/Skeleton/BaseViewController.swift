//
//  BaseViewController.swift
//  CKD
//
//  Created by casanube on 2020/12/4.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationController != nil {
            if (navigationController?.viewControllers.count)! > 1 {
                let back = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(goBack))
                back.image = UIImage.init(named: "back")
                navigationItem.leftBarButtonItem = back
            }
        }
                
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
   
    

}
