//
//  LocationSettingView.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/4/23.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class LocationSettingView: UIView {
    
    private let disposeBag = DisposeBag()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "위치 설정"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        
        return label
    }()
    
    let toggleSwitch: UISwitch = {
        let switchControl = UISwitch()
        return switchControl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .settingCellColor
        layer.cornerRadius = 10
        addViews()
        setConstraints()
        observeSwitchChanges()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(titleLabel)
        addSubview(toggleSwitch)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        })
        
        toggleSwitch.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
        })
    }
    
    func setSwitchState(isEnabled: Bool) {
        toggleSwitch.isOn = isEnabled
    }
    
    private func observeSwitchChanges() {
        toggleSwitch.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.openLocationPermissionSettings()
            })
            .disposed(by: disposeBag)
    }
    
    private func openLocationPermissionSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
}
