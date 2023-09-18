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
    var musicButtonTap = false
    
    let musicButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.tintColor = .white
        button.setImage(UIImage(systemName: "music.note"), for: .normal)
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(musicButtonTapped), for: .touchUpInside)
        button.invalidateIntrinsicContentSize()

        return button
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()

        let locationImage = UIImage(systemName: "location.circle.fill")?.withTintColor(.white)
        imageAttachment.image = locationImage
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: " 서울시 강남구"))

        label.attributedText = attributedString
        label.textColor = .white
        label.sizeToFit()

        return label
    }()
    
    let locationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .locationColor
//        button.setImage(UIImage(systemName: "location.circle.fill"), for: .normal)
//        button.setTitle("  울산 남구", for: .normal)
//        button.tintColor = .white
//        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.layer.cornerRadius = 3
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
       addSubview(locationButton)
       locationButton.addSubview(locationLabel)
    }
    
    private func setConstraints() {
        musicButtonConstraints()
        locationButtonConstraints()
        locationLabelConstraints()
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
    
    private func locationButtonConstraints() {
        locationButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            locationButton.heightAnchor.constraint(equalToConstant: 32),
            locationButton.widthAnchor.constraint(equalTo: locationLabel.widthAnchor, constant: 24),
            locationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            locationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func locationLabelConstraints() {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            locationLabel.leadingAnchor.constraint(equalTo: locationButton.leadingAnchor, constant: 12),
            locationLabel.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor)
        ])
    }
    
    @objc func musicButtonTapped() {
        musicButtonTap.toggle()
        
        musicButton.setImage(UIImage(systemName: musicButtonTap ? "speaker.slash.fill" : "music.note"), for: .normal)
     
        if musicButtonTap {
            let attributedString = NSMutableAttributedString(string: "")
            let imageAttachment = NSTextAttachment()

            let locationImage = UIImage(systemName: "location.circle.fill")?.withTintColor(.white)
            imageAttachment.image = locationImage
            attributedString.append(NSAttributedString(attachment: imageAttachment))
            attributedString.append(NSAttributedString(string: " 데이터데이터데이터"))
            
            locationLabel.attributedText = attributedString
        } else {
            let attributedString = NSMutableAttributedString(string: "")
            let imageAttachment = NSTextAttachment()

            let locationImage = UIImage(systemName: "location.circle.fill")?.withTintColor(.white)
            imageAttachment.image = locationImage
            attributedString.append(NSAttributedString(attachment: imageAttachment))
            attributedString.append(NSAttributedString(string: " 서울시 강남구"))
            
            locationLabel.attributedText = attributedString
        }
        
    }
}

extension TopBarView: CLLocationManagerDelegate {
    
}

