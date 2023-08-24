//
//  MainView.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/08/24.
//

import UIKit

class MainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .white
    }
}
