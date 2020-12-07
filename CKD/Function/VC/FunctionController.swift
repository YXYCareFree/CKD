//
//  FunctionController.swift
//  CKD
//
//  Created by casanube on 2020/12/7.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class FunctionController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(closeClicked), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { (m) in
            m.bottom.equalTo(-(keyWindow.safeAreaInsets.bottom + 25))
            m.centerX.equalTo(view)
        }
        
        
    }
    
    @objc func closeClicked(){
        dismiss(animated: true, completion: nil)
    }

}
