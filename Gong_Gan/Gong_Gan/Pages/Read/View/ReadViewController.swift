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
    private var didEditing = false
    private let disposeBag = DisposeBag()
    var selectedGalleryData: GalleryDataModel?
    private var viewModel: ReadViewModel!
    
    private let rainEffectView = RainEffectView()
    
    private let textViewColor: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        return view
    }()
    
    private let saveMemoButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        
        return button
    }()
    
//    lazy var backGroundView: UIImageView = {
//        let view = UIImageView(frame: UIScreen.main.bounds)
//        view.contentMode = UIView.ContentMode.scaleAspectFill
//        
//        return view
//    }()
    
    private let backGroundView = MainView()
    
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
    
    private let optionButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "ellipsis")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
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
        
        viewModel = ReadViewModel(selectedGalleryData: selectedGalleryData)
        
        addSubViews()
        setNaviBar()
        setConstraints()
        setupData()
        setupControl()
        setupSwipeGesture()
    }
    
    private func addSubViews() {
        view.addSubview(backGroundView)
        view.addSubview(rainEffectView)
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
        navigationItem.titleView = nowDateLabel
        if !didEditing {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: optionButton)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveMemoButton)
        }
    }
    
    private func setConstraints() {
        textViewColor.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        rainEffectView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        musicButton.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            $0.width.equalTo(36)
            $0.height.equalTo(36)
        })
        
        locationButton.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(22)
            $0.height.equalTo(31)
            $0.width.equalTo(locationLabel.snp.width).offset(24)
        })
        
        memoTextView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(31)
            $0.trailing.bottom.equalToSuperview().offset(-31)
            $0.top.equalTo(locationButton.snp.bottom).offset(24)
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
//        backGroundView.image = UIImage(named: selectedGalleryData!.imageName)
        self.backGroundView.playVideo(with: selectedGalleryData!.imageName)
        self.backGroundView.observePlayerDidPlayToEndTime()
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
    
    private func setEffect() {
        // 날씨에 따라 effect 들고오기
        let weather = selectedGalleryData?.weather
        
        if let weather = weather?.contains("rain") {
            // "rain"이 포함되어 있는 경우
            self.rainEffectView.isHidden = false
        } else {
            self.rainEffectView.isHidden = true
        }
    }
    
    private func setupSwipeGesture() {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeGesture.direction = .right
            view.addGestureRecognizer(swipeGesture)
        }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
            if gesture.direction == .right {
                handleBackButtonTap()
            }
        }
    
    // 특수한 view에서는 swipe를 다르게 설정해주어야 하기 때문에
    @objc private func handleBackButtonTap() {
            if didEditing {
                let alertController = UIAlertController(title: "뒤로 가시겠어요?", message: "변경된 내용은 저장되지 않아요. 😢", preferredStyle: .alert)

                let yesAction = UIAlertAction(title: "네", style: .destructive) { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }

                let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)

                alertController.addAction(noAction)
                alertController.addAction(yesAction)

                present(alertController, animated: true, completion: nil)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    
    private func setupControl() {
        backButton.rx.tap
            .flatMapLatest { [weak self] in
                return Observable.create { observer in
                    if self?.didEditing ?? false {
                        let alertController = UIAlertController(title: "뒤로 가시겠어요?", message: "변경된 내용은 저장되지 않아요. 😢", preferredStyle: .alert)
                        
                        let yesAction = UIAlertAction(title: "네", style: .destructive) { _ in
                            observer.onNext(true)
                            observer.onCompleted()
                        }
                        
                        let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in
                            observer.onNext(false)
                            observer.onCompleted()
                        }
                        
                        alertController.addAction(noAction)
                        alertController.addAction(yesAction)
                        
                        self?.present(alertController, animated: true, completion: nil)
                    } else {
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                    
                    return Disposables.create()
                }
            }
            .subscribe(onNext: { [weak self] shouldPop in
                if shouldPop {
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        optionButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.showOptionsMenu()
                })
                .disposed(by: disposeBag)
        
        memoTextView.rx.didBeginEditing
            .subscribe(onNext: { [weak self] in
                self?.locationButton.isHidden = true
                self?.timeLabel.isHidden = true
                self?.musicButton.isHidden = true
            })
            .disposed(by: disposeBag)
        
        memoTextView.rx.didEndEditing
            .subscribe(onNext: { [weak self] in
                self?.locationButton.isHidden = false
                self?.timeLabel.isHidden = false
                self?.musicButton.isHidden = false
            })
            .disposed(by: disposeBag)
        
        saveMemoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.updateMemo(newMemo: self.memoTextView.text) { error in
                    if let error = error {
                        print("일기 수정 실패: \(error.localizedDescription)")
                    } else {
                        self.didEditing = false
                        self.memoTextView.isEditable = false
                        self.setNaviBar()
                    }
                }
            }).disposed(by: disposeBag)
    }
    private func showOptionsMenu() {
        let editAction = UIAction(title: "수정", image: UIImage(systemName: "pencil")) { [weak self] _ in
            self?.memoTextView.isEditable = true
            self?.memoTextView.becomeFirstResponder()
            self?.didEditing = true
            self?.setNaviBar()
        }
        
        let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash")) {[weak self] _ in
            self?.showDeleteConfirmation()
        }
        
        let menu = UIMenu(children: [editAction, deleteAction])
        
        optionButton.menu = menu
        // 꾹 안눌러도 메뉴 뜨게 iOS 14이상 지원
        optionButton.showsMenuAsPrimaryAction = true
    }
    
    private func showDeleteConfirmation() {
        let alertController = UIAlertController(
            title: "정말 삭제하시나요?",
            message: "복구되지 않습니다!",
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            self?.deleteMemo()
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    private func deleteMemo() {
        viewModel.deleteMemo { [weak self] error in
            if let error = error {
                print("일기 삭제 실패: \(error.localizedDescription)")
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

