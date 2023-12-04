//
//  MyInfoView.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/4/23.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import FirebaseFirestore

class MyInfoView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 정보"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        
        return label
    }()
    
    private let platFormLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .settingArrowColor
        
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
        checkPlatform()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(titleLabel)
        addSubview(platFormLabel)
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
        
        platFormLabel.snp.makeConstraints({
            $0.trailing.equalTo(arrowImageView.snp.leading).offset(-3)
            $0.centerY.equalToSuperview()
        })
    }
    
    private func checkPlatform() {
        let uid = UserData.shared.getUserUid()
        let userDocumentRef = Firestore.firestore().collection("users").document(uid)
        
        userDocumentRef.getDocument { [weak self] (document, error) in
            guard let self = self, let document = document, document.exists, let data = document.data() else {
                // 처리 중에 오류가 발생하거나 데이터가 없을 경우
                return
            }
            
            if let platform = data["platform"] as? String {
                self.platFormLabel.text = platform
            }
        }
    }

}
