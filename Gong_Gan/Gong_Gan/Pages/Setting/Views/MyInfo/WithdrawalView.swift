//
//  WithdrawalView.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/5/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class WithdrawalView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원탈퇴"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        
        return label
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .settingArrowColor
        
        return imageView
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .settingCellColor
        layer.cornerRadius = 10
        addViews()
        setConstraints()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(titleLabel)
        addSubview(arrowImageView)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        })
        
        arrowImageView.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
        })
    }
    
    private func setupTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(withdrawalTapped))
            self.addGestureRecognizer(tapGesture)
            self.isUserInteractionEnabled = true
        }
    
    @objc private func withdrawalTapped() {
           NotificationCenter.default.post(name: Notification.Name("WithdrawalViewTapped"), object: nil)
       }

}
