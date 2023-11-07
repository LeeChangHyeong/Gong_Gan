//
//  TopBarView.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/09/14.
//

import UIKit
import CoreLocation
import SnapKit
import RxSwift
import RxCocoa

class TopBarView: UIView {
    private var locationManager = CLLocationManager()
    private var musicButtonTap = false
    private let diposeBag = DisposeBag()
    
    
    private let musicButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.tintColor = .white
        button.setImage(UIImage(systemName: "music.note"), for: .normal)
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(musicButtonTapped), for: .touchUpInside)
        button.invalidateIntrinsicContentSize()

        return button
    }()
    
    private let locationLabel: UILabel = {
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
    
    private let locationButton: UIButton = {
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
    
    private func addViews() {
       addSubview(musicButton)
       addSubview(locationButton)
       locationButton.addSubview(locationLabel)
    }
    
    private func setConstraints() {
        musicButtonConstraints()
        locationButtonConstraints()
        locationLabelConstraints()
        setLocationManager()
    }
    
    private func musicButtonConstraints() {
        musicButton.snp.makeConstraints({
            $0.height.equalTo(36)
            $0.width.equalTo(36)
            $0.bottom.equalToSuperview().offset(-28)
            $0.trailing.equalToSuperview().offset(-28)
        })
    }
    
    private func locationButtonConstraints() {
        locationButton.snp.makeConstraints({
            $0.height.equalTo(32)
            $0.width.equalTo(locationLabel.snp.width).offset(24)
            $0.bottom.equalToSuperview().offset(-30)
            $0.leading.equalToSuperview().offset(16)
        })
    }
    
    private func locationLabelConstraints() {
        locationLabel.snp.makeConstraints({
            $0.leading.equalTo(locationButton.snp.leading).offset(12)
            $0.centerY.equalTo(locationButton.snp.centerY)
        })
    }
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
    }
    
    @objc func musicButtonTapped() {
        musicButtonTap.toggle()
        
        musicButton.setImage(UIImage(systemName: musicButtonTap ? "speaker.slash.fill" : "music.note"), for: .normal)
     
    }
}

extension TopBarView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // 위치 정보를 가져와서 label에 적용
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let place = placemarks?.first {
                    let attributedString = NSMutableAttributedString(string: "")
                    let imageAttachment = NSTextAttachment()
                    
                    let locationImage = UIImage(named: "location.circle.fill")?.withTintColor(.white)
                    imageAttachment.image = locationImage
                    attributedString.append(NSAttributedString(attachment: imageAttachment))
                    attributedString.append(NSAttributedString(string: " \(place.locality ?? "") \(place.subLocality ?? "")"))
                    
                    self.locationLabel.attributedText = attributedString
                }
            }
        }
    }
}

