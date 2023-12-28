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
import FirebaseAuth
import FirebaseCore
import KakaoSDKUser

class TopBarView: UIView {
    
    
    private var locationManager = CLLocationManager()
    private var musicButtonTap = false
    
    private let disposeBag = DisposeBag()
    private let locationSubject = PublishSubject<CLLocation>()
    var viewModel: MainViewModel?
    
    weak var rainEffectView: RainEffectView?
    weak var snowEffectView: SnowEffectView?
    
    private let musicButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black.withAlphaComponent(0.2)
        button.tintColor = .white
        button.setImage(UIImage(named: "musicOn"), for: .normal)
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(musicButtonTapped), for: .touchUpInside)
        button.invalidateIntrinsicContentSize()
        
        return button
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        
        let locationImage = UIImage(named: "location")?.withTintColor(.white)
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
        button.backgroundColor = .black.withAlphaComponent(0.2)
        button.layer.cornerRadius = 6
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addViews()
        setConstraints()
        setLocationManager()
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
    }
    
    private func locationButtonConstraints() {
        locationButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(60)
            $0.height.equalTo(31)
            $0.width.equalTo(locationLabel.snp.width).offset(24)
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(24)
        })
    }
    
    private func musicButtonConstraints() {
        musicButton.snp.makeConstraints({
            $0.height.equalTo(36)
            $0.width.equalTo(36)
//            $0.bottom.equalToSuperview().offset(-20)
            $0.trailing.equalToSuperview().offset(-28)
            $0.centerY.equalTo(locationButton)
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
    }
    
    func bindToLocationUpdate(completion: @escaping () -> Void) {
        locationSubject
            // 한 번만 실행
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self ] location in
                CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                    if let place = placemarks?.first {
                        let attributedString = NSMutableAttributedString(string: "")
                        let imageAttachment = NSTextAttachment()
                        
                        let locationImage = UIImage(named: "location")?.withTintColor(.white)
                        imageAttachment.image = locationImage
                        attributedString.append(NSAttributedString(attachment: imageAttachment))
                        
                        let textAttributes: [NSAttributedString.Key: Any] = [
                            .font: UIFont.systemFont(ofSize: 15, weight: .regular),
                            .foregroundColor: UIColor.white
                        ]
                    
                        attributedString.append(NSAttributedString(string: " \(place.locality ?? "") \(place.subLocality ?? "")", attributes: textAttributes))
                        
                        self?.viewModel?.currentLocation.accept(" \(place.locality ?? "") \(place.subLocality ?? "")")
                        
                        // 위도 경도 들고오기
                        let latitude = place.location?.coordinate.latitude
                        let longitude = place.location?.coordinate.longitude
                        
                        self?.viewModel?.getWeather(lat: latitude!, lon: longitude!)
                            .subscribe(onNext: { weatherModel in
                                // 가져온 날씨 정보를 출력
                                print("Temperature: \(weatherModel.main.temp) ℃")
                                print("Min Temperature: \(weatherModel.main.tempMin) ℃")
                                print("Max Temperature: \(weatherModel.main.tempMax) ℃")
                                print("Weather Description: \(weatherModel.weather.first?.main ?? "N/A")")
                                
                                completion()
                                self?.viewModel?.currentWeather.accept(weatherModel)
                                
//                                if let weatherDescription = weatherModel.weather.first?.main.lowercased(), weatherDescription.contains("rain") {
//                                    // "rain"이 포함되어 있는 경우
//                                    // 처리할 내용을 여기에 작성
//                                    self?.rainEffectView?.isHidden = false
//                                } else {
//                                    // "rain"이 포함되어 있지 않은 경우
//                                    // 처리할 내용을 여기에 작성
//                                    self?.rainEffectView?.isHidden = true
//                                }
                                
                                if let weatherDescription = weatherModel.weather.first?.main.lowercased() {
                                    if weatherDescription.contains("rain") {
                                        self?.rainEffectView?.isHidden = false
                                        self?.snowEffectView?.isHidden = true
                                    } else if weatherDescription.contains("snow") {
                                        self?.rainEffectView?.isHidden = true
                                        self?.snowEffectView?.isHidden = false
                                    } else {
                                        self?.rainEffectView?.isHidden = true
                                        self?.snowEffectView?.isHidden = true
                                    }
                                }
                                
                            }, onError: { error in
                                // 에러가 발생한 경우 출력
                                print("Error fetching weather: \(error.localizedDescription)")
                            })
                            .disposed(by: self!.disposeBag)
                        
                        self?.locationLabel.attributedText = attributedString
                        
                        // 위치를 가지고 왔으면 업데이트 중지
                        self?.locationManager.stopUpdatingLocation()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
  
    @objc func musicButtonTapped() {
        musicButtonTap.toggle()
        
        musicButton.setImage(UIImage(named: musicButtonTap ? "musicOff" : "musicOn"), for: .normal)
    }
}

extension TopBarView: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // 위치 업데이트를 subject에 전달하여 구독자들에게 알림
            locationSubject.onNext(location)
        }
    }
    
}

