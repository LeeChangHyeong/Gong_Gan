//
//  OnBoardingPageViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 1/2/24.
//

import UIKit
import SnapKit

class OnBoardingPageViewController: UIViewController {
        
        private var imageView = UIImageView()
        private var titleLabel = UILabel()
        private var subTitleLabel = UILabel()

        override func viewDidLoad() {
            super.viewDidLoad()

            setupUI()
            setupLayout()
        }
        
        init(imageName: String, title: String, subTitle: String) {
            super.init(nibName: nil, bundle: nil)
            imageView.image = UIImage(named: imageName)
            titleLabel.text = title
            titleLabel.textColor = .white
            subTitleLabel.text = subTitle
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI() {
            view.backgroundColor = .mainBackGroundColor
            
            imageView.contentMode = .scaleAspectFill
        }
        
        private func setupLayout() {
            view.addSubview(titleLabel)
            titleLabel.snp.makeConstraints({
                $0.top.equalToSuperview().offset(160)
                $0.centerX.equalToSuperview()
            })
            
            view.addSubview(subTitleLabel)
            subTitleLabel.snp.makeConstraints({
                $0.top.equalTo(titleLabel.snp.bottom).offset(20)
                $0.centerX.equalTo(titleLabel)
            })
            
            view.addSubview(imageView)
            imageView.snp.makeConstraints({
                $0.top.equalTo(subTitleLabel.snp.bottom).offset(50)
                $0.centerX.equalTo(titleLabel)
            })
        }

}
