//
//  CameraModePickerView.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/09/14.
//

import UIKit

class CameraModePickerView: UIPickerView {
    let captureModesList = ["Default","Sepia","Warm","Cool","Vivid", "Noir"]
    var cameraModePicker = UIPickerView()
    // 가로로 뒤집기
    var rotationAngle: CGFloat = -90 * (.pi/180)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

