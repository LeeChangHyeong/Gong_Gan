//
//  SettingCollectionViewCell.swift
//  GoodDoctor
//
//  Created by 이창형 on 2023/08/25.
//

import UIKit

class SettingCollectionViewCell: UICollectionViewCell {
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "서울"
        label.textColor = .black
        label.font = UIFont(name: "NanumSquareEB", size: 13)
        
        return label
    }()
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupLayout()
            setConstraints()
        }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func setupLayout() {
        contentView.addSubview(mainLabel)
        backgroundColor = .white
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 18
        contentView.layer.borderWidth = 1
    }
    
    func setConstraints() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
