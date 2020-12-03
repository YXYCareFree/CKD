//
//  Const.swift
//  CKD
//
//  Created by casanube on 2020/11/11.
//  Copyright © 2020 casanube. All rights reserved.
//

import UIKit
@_exported import Kingfisher
@_exported import SnapKit
@_exported import ESPullToRefresh


let screenW = UIScreen.main.bounds.size.width
let screenH = UIScreen.main.bounds.size.height

let Color9 = "0x999999".toUIColor()
let Color3 = "0x333333".toUIColor()
let Color6 = "0x666666".toUIColor()


func PingFang(size: CGFloat) -> UIFont {
    return UIFont.init(name: "PingFang SC", size: size) ?? UIFont.systemFont(ofSize: size)
}

let keyWindow = getKeyWindow()
func getKeyWindow() -> UIWindow {
    let windows = UIApplication.shared.windows
    for window in windows {
        if window.isKind(of: UIWindow.self) && window.windowLevel == .normal && window.bounds.equalTo(UIScreen.main.bounds) {
            return window
        }
    }
    return UIApplication.shared.keyWindow!
}

extension UIImageView {
    func setNetworkImage(urlStr:String?) {
//        print(urlStr ?? "图片地址为空")
        var url = "12"
        if let u = urlStr {
            if u.hasPrefix("https:") {
                url = u
            }else{
                url = "https://registry.casanubeserver.com/casanube-file-service/casanube/file/" + u + "/download.run"
            }
            
        }
        self.kf.setImage(with: .network(URL(string: url)!), placeholder: UIImage.init(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
    }
}

