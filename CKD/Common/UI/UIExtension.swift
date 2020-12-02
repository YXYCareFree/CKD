//
//  UIExtension.swift
//  CKD
//
//  Created by casanube on 2020/11/27.
//  Copyright © 2020 casanube. All rights reserved.
//

import Foundation
import UIKit

extension String{
    
    func toUIColor(alpha: CGFloat = 1.0) -> UIColor {
        var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
         var hex = self
         // 如果传入的十六进制颜色有前缀，去掉前缀
         if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
          hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
         } else if hex.hasPrefix("#") {
          hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
         }
         // 如果传入的字符数量不足6位按照后边都为0处理，当然你也可以进行其它操作
         if hex.count < 6 {
          for _ in 0..<6-hex.count {
           hex += "0"
          }
         }
        
         // 分别进行转换
         // 红
         Scanner(string: String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])).scanHexInt64(&red)
         // 绿
         Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])).scanHexInt64(&green)
         // 蓝
         Scanner(string: String(hex[hex.index(startIndex, offsetBy: 4)...])).scanHexInt64(&blue)
        
         return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
}

extension UIViewController {
    func setTabBar(title: String, norImg: String, selImg: String) {
        tabBarItem.title = title
        tabBarItem.image = UIImage.init(named: norImg)?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage.init(named: selImg)?.withRenderingMode(.alwaysOriginal)
    }
}
