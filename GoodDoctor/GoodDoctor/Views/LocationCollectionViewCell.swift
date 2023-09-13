//
//  LocationCollectionViewCell.swift
//  GoodDoctor
//
//  Created by 이창형 on 2023/08/26.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    
    let pharmacyLabel: UILabel = {
        let label = UILabel()
        label.text = "약국"
        label.textColor = UIColor.pharmacyColor
        label.font = UIFont(name: "JalnanOTF", size: 11)
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "착한의사약국"
        label.textColor = .black
        label.font = UIFont(name: "NanumSquareEB", size: 17)
        
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "150m ・ 서울시 강남구 논현동 11-28 6층"
        label.textColor = .black
        label.font = UIFont(name: "NanumSquareR", size: 13)
        
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
        contentView.addSubview(pharmacyLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(distanceLabel)
        
        backgroundColor = .white
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.shadowColor = UIColor.shadowColor.cgColor
    }
    
    func setConstraints() {
        pharmacyLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pharmacyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23),
            pharmacyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: pharmacyLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24)
        ])
        
        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            distanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24)
        ])
    }
    
    //    let timeLabel: UILabel = {
    //        let label = UILabel()
    //        label.text = "9:00-19:00"
    //        label.textColor = .black
    //        label.font = UIFont(name: "NanumSquareB", size: 13)
    //
    //        return label
    //    }()
}
