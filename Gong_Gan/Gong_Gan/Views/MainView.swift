//
//  MainView.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/08/24.
//

import UIKit

class MainView: UIView {
    let backGroundView: UIImageView = {
        let view = UIImageView(frame: UIScreen.main.bounds)
        view.image = UIImage(named: "1")!
        view.contentMode =  UIView.ContentMode.scaleAspectFill
        
        return view
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(backGroundView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
