//
//  MainView.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/08/24.
//

import UIKit

class MainView: UIView {
    
    lazy var backGroundView: UIImageView = {
        let view = UIImageView(frame: UIScreen.main.bounds)
        view.image = UIImage(named: "도시")!
        view.contentMode = UIView.ContentMode.scaleAspectFill
        view.isUserInteractionEnabled = true

        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(backGroundView)
    }
}


