//
//  VersionView.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/4/23.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class VersionView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "버전"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        
        return label
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .settingArrowColor
        
        return label
    }()
    
    private let updateLabel: UILabel = {
        let label = UILabel()
        label.text = "최신 버전입니다"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .settingArrowColor
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .settingCellColor
        layer.cornerRadius = 10
        addViews()
        setConstraints()
        checkAppVersion()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(titleLabel)
        addSubview(updateLabel)
        addSubview(versionLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        })
        
        versionLabel.snp.makeConstraints({
            $0.leading.equalTo(titleLabel.snp.trailing).offset(6)
            $0.centerY.equalToSuperview()
        })
        
        updateLabel.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
        })
    }
    
    // TODO: 앱스토어에 출시 했을때 버전 들고와서 비교하여 최신 버전인지 아닌지 나타내주는 기능 추가로 구현해야함
    private func checkAppVersion() {
        // 앱 버전을 가져와서 설정합니다.
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionLabel.text = appVersion
    }

}
