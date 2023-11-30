//
//  ReadViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/29/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth


class ReadViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var selectedGalleryData: GalleryDataModel?
    
    private let textViewColor: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        return view
    }()
    
    lazy var backGroundView: UIImageView = {
        let view = UIImageView(frame: UIScreen.main.bounds)
        view.contentMode = UIView.ContentMode.scaleAspectFill
        
        return view
    }()
    
    private let memoTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.textColor = .white
        view.text = "터치하여 오늘의 일기를 작성하세요"
        view.font = UIFont(name: "ArialHebrew", size: 15)
        view.isEditable = false
        
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
            let image = UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
            button.setImage(image, for: .normal)

            button.tintColor = .white
            
            return button
    }()
    
    private let nowDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .light)
        
        return label
    }()
    
//    private let saveMemoButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("완료", for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
//        
//        return button
//    }()
    
    private let musicButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.tintColor = .white
        button.setImage(UIImage(systemName: "music.note"), for: .normal)
        button.layer.cornerRadius = 18
//        button.addTarget(self, action: #selector(musicButtonTapped), for: .touchUpInside)
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
        button.backgroundColor = .locationColor
        button.layer.cornerRadius = 6
        
        return button
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "오전 10:03"
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setNaviBar()
        setConstraints()
        setupData()
        setupControl()
    }
    
    private func addSubViews() {
        view.addSubview(backGroundView)
        backGroundView.addSubview(textViewColor)
        view.addSubview(memoTextView)
        view.addSubview(musicButton)
        view.addSubview(locationButton)
        locationButton.addSubview(locationLabel)
        view.addSubview(timeLabel)
    }
    
    private func setNaviBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//        navigationItem.titleView = nowDateLabel
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveMemoButton)
    }
    
    private func setConstraints() {
        memoTextView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(31)
            $0.trailing.bottom.equalToSuperview().offset(-31)
            $0.top.equalToSuperview().offset(167)
        })
        
        textViewColor.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        musicButton.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(113)
            $0.width.equalTo(36)
            $0.height.equalTo(36)
        })
        
        locationButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(118)
            $0.leading.equalToSuperview().offset(22)
            $0.height.equalTo(31)
            $0.width.equalTo(locationLabel.snp.width).offset(24)
        })
        
        timeLabel.snp.makeConstraints({
            $0.centerY.equalTo(locationButton)
            $0.leading.equalTo(locationButton.snp.trailing).offset(12)
        })
        
        locationLabel.snp.makeConstraints({
            $0.leading.equalTo(locationButton.snp.leading).offset(12)
            $0.centerY.equalTo(locationButton.snp.centerY)
        })
}
    
    private func setupData() {
        memoTextView.text = selectedGalleryData?.memo
        backGroundView.image = UIImage(named: selectedGalleryData!.imageName)
        nowDateLabel.text = selectedGalleryData?.date
        
        // locationLabel의 attributedText 설정
        let newLocationText = (selectedGalleryData?.location)!
            let newLocationAttributedString = NSAttributedString(string: newLocationText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

            let imageAttachment = NSTextAttachment()
            let locationImage = UIImage(named: "location")?.withTintColor(.white)
            imageAttachment.image = locationImage

            let finalAttributedString = NSMutableAttributedString(attachment: imageAttachment)
            finalAttributedString.append(newLocationAttributedString)

            locationLabel.attributedText = finalAttributedString
            timeLabel.text = selectedGalleryData?.time
        
    }
    
    private func setupControl() {
        backButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                })
                .disposed(by: disposeBag)

    }
    
}

