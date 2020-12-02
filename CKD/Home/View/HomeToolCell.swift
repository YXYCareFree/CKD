//
//  HomeToolCell.swift
//  CKD
//
//  Created by casanube on 2020/11/26.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

class HomeToolCell: UITableViewCell {
    
    var data: [ToolModel]? {
        didSet{
            selectionStyle = .none
            layoutSubviews()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }
    
    func setUI() {
        if data == nil {
            return
        }
                    
        for v in contentView.subviews {
            v.removeFromSuperview()
        }
        
        let w = (screenW - 30 - 24) / 4
        let colors = [["0xDCE7FF".toUIColor().cgColor, "0xDCE7FF".toUIColor().cgColor], ["0xDDF8D6".toUIColor().cgColor, "0xDDF8D6".toUIColor().cgColor], ["0xFFF9E6".toUIColor().cgColor, "0xFFDC81".toUIColor().cgColor], ["0xEBEEFF".toUIColor().cgColor, "0x79B6FF".toUIColor().cgColor]]
       
        let titleColors = ["0x576CBB".toUIColor(), "0x67AC55".toUIColor(), "0xEF8741".toUIColor(), "0x576CBB".toUIColor()]
        
        for i in 0..<data!.count {
            let model = data![i]
            let v = HomeToolView(title: model.toolName, imgUrl: model.toolImg, color: titleColors[i],clicked: {
                print("点击了\(model.toolName!)")
            })
            let layer = CAGradientLayer()
            layer.locations = [0, 1]
            layer.startPoint = CGPoint(x: 1, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
            layer.colors = colors[i]
            v.layer.insertSublayer(layer, at: 0)
            
            contentView.addSubview(v)
            v.snp.makeConstraints { (m) in
                m.left.equalTo(CGFloat(15 + i * (Int(w) + 8)))
                m.width.equalTo(w)
//                m.height.equalTo(w * 65 / 80)
                m.top.equalTo(12)
                m.bottom.equalTo(-10)
            }
           
            contentView.setNeedsLayout()
            contentView.layoutIfNeeded()
           
            layer.frame = v.bounds
        }
    }
}
