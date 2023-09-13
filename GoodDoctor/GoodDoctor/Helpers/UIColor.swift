//
//  UIColor.swift
//  GoodDoctor
//
//  Created by 이창형 on 2023/08/25.
//

import UIKit

extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
            var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
            
            if hexFormatted.hasPrefix("#") {
                hexFormatted = String(hexFormatted.dropFirst())
            }
            
            assert(hexFormatted.count == 6, "Invalid hex code used.")
            
            var rgbValue: UInt64 = 0
            Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
            
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: alpha)
        }
    
    static let cellBackGround = UIColor(hexCode: "F9F6F7")
    static let cellText = UIColor(hexCode: "B5487E")
    static let cellBorderColor = UIColor(hexCode: "DE85B4")
    static let pharmacyColor = UIColor(hexCode: "EF9ADB")
    static let shadowColor = UIColor(hexCode: "000000").withAlphaComponent(0.12)
}
