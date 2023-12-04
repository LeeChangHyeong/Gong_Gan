//
//  SettingViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/2/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import CoreLocation

class SettingViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let myInfoView = MyInfoView()
    private let locationSettingView = LocationSettingView()
    private let versionView = VersionView()
    private let inquriyView = InquiryView()
    
    private let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        button.setImage(image, for: .normal)
        
        button.tintColor = .white
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "설정"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLocationPermission()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .galleryColor
        setNaviBar()
        addSubView()
        setConstraints()
        setupControl()
    }
    
    private func setNaviBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.titleView = titleLabel
    }
    
    private func addSubView() {
        view.addSubview(myInfoView)
        view.addSubview(locationSettingView)
        view.addSubview(versionView)
        view.addSubview(inquriyView)
    }
    
    private func setConstraints() {
        myInfoView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.height.equalTo(50)
        })
        
        locationSettingView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(myInfoView.snp.bottom).offset(8)
            $0.height.equalTo(50)
        })
        
        versionView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(locationSettingView.snp.bottom).offset(40)
            $0.height.equalTo(50)
        })
        
        inquriyView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(versionView.snp.bottom).offset(8)
            $0.height.equalTo(50)
        })
    }
    
    private func setupControl() {
        backButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        // 뷰가 backGround에서 foreGround로 들어올때 실행하여 위치 권한을 변경하지 않고 들어올때도 switch 상태 유지
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.updateLocationPermission()
            })
            .disposed(by: disposeBag)
    }
    
    func updateLocationPermission() {
        var locationPermissionEnabled = false
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            locationPermissionEnabled = false
        } else {
            locationPermissionEnabled = true
        }
        
        // LocationSettingView에서 switch 상태를 업데이트합니다.
        locationSettingView.setSwitchState(isEnabled: locationPermissionEnabled)
    }
}

