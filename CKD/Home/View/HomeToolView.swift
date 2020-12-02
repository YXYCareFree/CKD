//
//  HomeToolView.swift
//  CKD
//
//  Created by casanube on 2020/11/25.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class HomeToolView: UIView {
    var _title: String
    var _imgUrl: String
    var clickBlcok: () -> Void?
    var titleColor: UIColor = .black
    
    
    
    init(title: String?, imgUrl: String?, color: UIColor,clicked: @escaping () -> Void?) {
        _title = title ?? ""
        _imgUrl = imgUrl ?? "https://www.baidu.com"
        clickBlcok = clicked
        titleColor = color
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
        let imgV = UIImageView.init(frame: .zero)
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        imgV.setNetworkImage(urlStr: _imgUrl)
        addSubview(imgV)
        imgV.snp.makeConstraints { (m) in
            m.left.equalTo(8)
            m.width.height.equalTo(28).priority(.high)
            m.top.equalTo(5)
        }
        
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.text = _title
        lbl.numberOfLines = 1
        addSubview(lbl)
        lbl.snp.makeConstraints { (m) in
            m.left.equalTo(8)
            m.top.equalTo(imgV.snp.bottom).offset(4)
            m.bottom.equalTo(-10)
        }

        layer.cornerRadius = 4
        clipsToBounds = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clicked))
        addGestureRecognizer(tap)
    }
    
    @objc func clicked(){
        if clickBlcok != nil {
            clickBlcok()
        }
    }
    
    
}
