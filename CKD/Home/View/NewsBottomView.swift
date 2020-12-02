//
//  NewsBottomView.swift
//  CKD
//
//  Created by casanube on 2020/11/30.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class NewsBottomView: UIView {
    
    lazy var btnLike: UIButton = {
        let t = UIButton(type: .custom)
        t.setImage(UIImage.init(named: "dislike"), for: .normal)
        t.titleLabel?.font = PingFang(size: 12)
        t.setTitle(" 0", for: .normal)
        t.setTitleColor("0x999999".toUIColor(), for: .normal)
        return t
    }()
    
    lazy var btnCollect: UIButton = {
        let t = UIButton(type: .custom)
        t.setImage(UIImage.init(named: "collect"), for: .normal)
        t.titleLabel?.font = PingFang(size: 12)
        t.setTitle(" 0", for: .normal)
        t.setTitleColor("0x999999".toUIColor(), for: .normal)
        return t
    }()
    
    lazy var btnRead: UIButton = {
        let t = UIButton(type: .custom)
        t.setImage(UIImage.init(named: "unread"), for: .normal)
        t.titleLabel?.font = PingFang(size: 12)
        t.setTitle(" 0", for: .normal)
        t.setTitleColor("0x999999".toUIColor(), for: .normal)
        return t
    }()
    
    lazy var lblAuthor: UILabel = {
        let lbl = UILabel()
        lbl.font = PingFang(size: 12)
        lbl.textColor = Color9
        lbl.text = "家云健康"
        return lbl
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    func setUI() {
        
        addSubview(lblAuthor)
        lblAuthor.snp.makeConstraints { (m) in
            m.left.equalTo(0)
            m.centerY.equalTo(self)
        }
        
        addSubview(btnLike)
        btnLike.snp.makeConstraints { (m) in
            m.right.equalTo(0)
            m.top.bottom.equalTo(0)
        }
        
        let split = UIView()
        split.backgroundColor = "0xdddddd".toUIColor()
        addSubview(split)
        split.snp.makeConstraints { (m) in
            m.right.equalTo(btnLike.snp.left).offset(-5)
            m.centerY.equalTo(self)
            m.width.equalTo(0.5)
            m.height.equalTo(10)
        }
        
        addSubview(btnCollect)
        btnCollect.snp.makeConstraints { (m) in
            m.right.equalTo(split.snp.left).offset(-5)
        }
        
        let split1 = UIView()
        split1.backgroundColor = "0xdddddd".toUIColor()
        addSubview(split1)
        split1.snp.makeConstraints { (m) in
            m.right.equalTo(btnCollect.snp.left).offset(-5)
            m.width.equalTo(0.5)
            m.height.equalTo(10)
            m.centerY.equalTo(self)
        }
        
        addSubview(btnRead)
        btnRead.snp.makeConstraints { (m) in
            m.right.equalTo(split1.snp.left).offset(-5)
        }
        
    }
    
}
