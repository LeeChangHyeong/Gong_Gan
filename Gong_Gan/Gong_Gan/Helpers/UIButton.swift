//
//  UIButton.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/09/13.
//

import UIKit

extension UIButton {
    var circleButton: Bool {
        set {
            if newValue {
                self.layer.cornerRadius = 0.5 * self.bounds.size.width
            } else {
                self.layer.cornerRadius = 0
            }
        } get {
            return false
        }
    }
}
