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
    private let snowEffectView = SnowEffectView()
    
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
    
    private let brandImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "brandIcon")
        
        return view
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
    
    private let locationLabel: UILabel = {
       let label = UILabel()
        label.text = "위치를 불러올 수 없습니다."
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .captionColor
        
        return label
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
        setEffect()
        setNaviBar()
        setConstraints()
        setupData()
        setupControl()
        setupSwipeGesture()
    }
    
    private func addSubViews() {
        view.addSubview(backGroundView)
        view.addSubview(rainEffectView)
        view.addSubview(snowEffectView)
        view.addSubview(textViewColor)
        view.addSubview(memoTextView)
        view.addSubview(brandImage)
        view.addSubview(locationLabel)
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
        
        snowEffectView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        brandImage.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(12)
            $0.height.equalTo(12)
        })
        
        locationLabel.snp.makeConstraints({
            $0.centerY.equalTo(brandImage)
            $0.leading.equalTo(brandImage.snp.trailing).offset(4)
        })
        
        memoTextView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(31)
            $0.trailing.bottom.equalToSuperview().offset(-31)
            $0.top.equalTo(brandImage.snp.bottom).offset(24)
        })
        
//        locationButton.snp.makeConstraints({
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
//            $0.leading.equalToSuperview().offset(22)
//            $0.height.equalTo(31)
//            $0.width.equalTo(locationLabel.snp.width).offset(24)
//        })
        
//        timeLabel.snp.makeConstraints({
//            $0.centerY.equalTo(locationButton)
//            $0.leading.equalTo(locationButton.snp.trailing).offset(12)
//        })
//        
//        locationLabel.snp.makeConstraints({
//            $0.leading.equalTo(locationButton.snp.leading).offset(12)
//            $0.centerY.equalTo(locationButton.snp.centerY)
//        })
}
    
    private func setupData() {
        memoTextView.text = selectedGalleryData?.memo
//        backGroundView.image = UIImage(named: selectedGalleryData!.imageName)
        
        self.backGroundView.playVideo(with: selectedGalleryData!.imageName)
        self.backGroundView.observePlayerDidPlayToEndTime()
        nowDateLabel.text = selectedGalleryData?.date
        
        // locationLabel의 attributedText 설정
        
        let location = selectedGalleryData!.location
        let time = selectedGalleryData!.time

            let attributedString = NSMutableAttributedString(string: "\(location) 에서 \(time) 에 작성한 기록")

            // 색상을 변경하려는 부분에 대한 범위를 설정
        let locationRange = (attributedString.string as NSString).range(of: location)
        let timeRange = (attributedString.string as NSString).range(of: time)

            // NSAttributedString에 속성 추가
        attributedString.addAttribute(.foregroundColor, value: UIColor.brandColor, range: locationRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.brandColor, range: timeRange)

            // 최종적으로 설정된 NSAttributedString을 레이블에 할당
            locationLabel.attributedText = attributedString
        
    }
    
    private func setEffect() {
        if let weather = selectedGalleryData?.weather {
            if weather.description.lowercased().contains("rain") {
                rainEffectView.isHidden = false
                snowEffectView.isHidden = true
            } else if weather.description.lowercased().contains("snow") {
                rainEffectView.isHidden = true
                snowEffectView.isHidden = false
            } else {
                rainEffectView.isHidden = true
                snowEffectView.isHidden = true
            }
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
            
                self?.brandImage.isHidden = true
                self?.locationLabel.isHidden = true
            })
            .disposed(by: disposeBag)
        
        memoTextView.rx.didEndEditing
            .subscribe(onNext: { [weak self] in
                self?.brandImage.isHidden = false
                self?.locationLabel.isHidden = false
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

