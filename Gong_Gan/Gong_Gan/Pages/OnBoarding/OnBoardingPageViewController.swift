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
        imageView.contentMode = .scaleAspectFill
        
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 32, weight: .semibold)
        titleLabel.textColor = .white

        let coloredTextsForTitle: [(text: String, color: UIColor, font: UIFont)] = [("어떤 순간", .brandColor, .systemFont(ofSize: 32, weight: .semibold)),
                                                                                             ("나만의 공간", .brandColor, .systemFont(ofSize: 32, weight: .semibold)),
                                                                                             ("변하지 않는", .brandColor, .systemFont(ofSize: 32, weight: .semibold))]
        titleLabel.attributedText = attributedText(with: title, coloredTexts: coloredTextsForTitle)
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        subTitleLabel.text = subTitle
        subTitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subTitleLabel.textColor = .white
        subTitleLabel.textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        view.backgroundColor = .mainBackGroundColor

        imageView.contentMode = .scaleAspectFit
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
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
            $0.height.equalTo(UIScreen.main.bounds.height/3)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.centerX.equalTo(titleLabel)
        })
    }

    private func attributedText(with text: String, coloredTexts: [(text: String, color: UIColor, font: UIFont)]) -> NSAttributedString {
            let attributedString = NSMutableAttributedString(string: text)

            for coloredText in coloredTexts {
                let coloredRange = (text as NSString).range(of: coloredText.text)
                attributedString.addAttribute(.foregroundColor, value: coloredText.color, range: coloredRange)
                attributedString.addAttribute(.font, value: coloredText.font, range: coloredRange)
            }

            return attributedString
        }
}
