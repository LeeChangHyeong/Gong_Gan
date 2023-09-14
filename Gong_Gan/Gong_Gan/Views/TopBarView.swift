//
//  TopBarView.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/09/14.
//

import UIKit
import CoreLocation

class TopBarView: UIView {
    var locationManager = CLLocationManager()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
       
    }
    
    private func setConstraints() {
    
    }
    
    private func setLocationManager() {
        
    }
    
}

extension TopBarView: CLLocationManagerDelegate {
    
}
