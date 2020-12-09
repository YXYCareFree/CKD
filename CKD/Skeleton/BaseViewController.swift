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
        
        view.backgroundColor = .white
        if navigationController != nil {
            if (navigationController?.viewControllers.count)! > 1 {
                let back = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(goBack))
                back.image = UIImage.init(named: "back")
                navigationItem.leftBarButtonItem = back
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEdit))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func endEdit(){
        view.window?.endEditing(true)
    }
    
   
    

}
