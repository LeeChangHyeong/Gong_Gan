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
//    speaker.slash.fill
    var musicButtonTap = false
    
    let musicButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.tintColor = .white
        button.setImage(UIImage(systemName: "music.note"), for: .normal)
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(musicButtonTapped), for: .touchUpInside)
        
        return button
    }()

    
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
       addSubview(musicButton)
    }
    
    private func setConstraints() {
        musicButtonConstraints()
    }
    
    private func setLocationManager() {
        
    }
    
    private func musicButtonConstraints() {
        musicButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            musicButton.heightAnchor.constraint(equalToConstant: 36),
            musicButton.widthAnchor.constraint(equalToConstant: 36),
            musicButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -28),
            musicButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    @objc func musicButtonTapped() {
        musicButtonTap.toggle()
        
        musicButton.setImage(UIImage(systemName: musicButtonTap ? "speaker.slash.fill" : "music.note"), for: .normal)
     
        
    }
}

extension TopBarView: CLLocationManagerDelegate {
    
}
