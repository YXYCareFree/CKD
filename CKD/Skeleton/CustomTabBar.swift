//
//  CustomTabBar.swift
//  CKD
//
//  Created by casanube on 2020/12/1.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit

var once: Int = 0

class CustomTabBar: UITabBar {

    private var centerV: UIView?
        
    override func layoutSubviews() {
        super.layoutSubviews()

        if once == 0 {
            once += 1
            let a: [UIView] = subviews.compactMap { v in
                if v.isKind(of: NSClassFromString("UITabBarButton")!.self) {
                    return v
                }
                return nil
            }
            if a.count % 2 == 0 {
                return
            }
            
            let v = a[a.count / 2]
            
            var w: CGFloat? = 50
            for j in 0..<v.subviews.count {
                if v.subviews[j].isKind(of: UIImageView.self) {
                    let imgV = v.subviews[j] as! UIImageView
                    w = imgV.image?.size.width
                }
            }
            v.snp.remakeConstraints { (m) in
                m.centerY.equalTo(8)
                m.centerX.equalTo(v.superview!.snp.centerX)
                m.width.height.equalTo(w!)
            }
            self.centerV = v
        }
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let con = convert(point, to: centerV)
        if (centerV?.point(inside: con, with: event))! {
            return centerV
        }
        
        return super.hitTest(point, with: event)
    }
}
