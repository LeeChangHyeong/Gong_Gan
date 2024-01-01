//
//  WriteViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/12/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import CoreLocation


class WriteViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private var locationManager = CLLocationManager()
    private var musicButtonTap = false
    
    var viewModel: WriteViewModel?
    var backgroundImage: UIImage?
    var mainViewModel: MainViewModel?
    private var rainEffectView = RainEffectView()
    private var snowEffectView = SnowEffectView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let locationSubject = PublishSubject<CLLocation>()
    
    private let textViewColor: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        return view
    }()
    
    private let backGroundView = MainView()
    
    private let memoTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.textColor = .white
        view.text = "터치하여 오늘의 일기를 작성하세요"
        view.font = UIFont(name: "ArialHebrew", size: 15)
        
        return view
    }()
    
    private let brandImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "brandIcon")
        
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
    
    private let saveMemoButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        
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

        addSubViews()
        setEffect()
        setNaviBar()
        setConstraints()
        setupControl()
        setupSwipeGesture()
        setLabel()
    }
    
    private func addSubViews() {
        view.addSubview(backGroundView)
        view.addSubview(textViewColor)
        view.addSubview(rainEffectView)
        view.addSubview(snowEffectView)
        view.addSubview(memoTextView)
        view.addSubview(locationLabel)
        view.addSubview(brandImage)
    }
    
    private func setLabel() {
        let location = mainViewModel!.currentLocation.value
            let time = timeLabel.text!

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
    
    private func setNaviBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.titleView = nowDateLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveMemoButton)
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
    
    @objc private func handleBackButtonTap() {
        
        let alertController = UIAlertController(title: "뒤로 가시겠어요?", message: "변경된 내용은 저장되지 않아요. 😢", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "네", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupControl() {
        // WriteViewModel의 backgroundImage를 구독하여 값이 업데이트될 때마다 실행되는 클로저 정의
        viewModel?.backgroundImage
            .subscribe(onNext: { [weak self] image in
                // 값이 업데이트되면 받아온 이미지를 배경으로 설정
//                self?.backGroundView.image = UIImage(named: image!)
                self?.backGroundView.playVideo(with: image!)
                self?.backGroundView.observePlayerDidPlayToEndTime()
            })
            .disposed(by: disposeBag)
        
        memoTextView.rx.text
            .bind(to: viewModel!.memoText)
            .disposed(by: disposeBag)
        
        memoTextView.rx.didBeginEditing
            .take(1)
            .subscribe(onNext: { [weak self] in
                self?.memoTextView.text = ""
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
        
        backButton.rx.tap
            .flatMapLatest { [weak self] in
                return Observable.create { observer in
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
                    
                    return Disposables.create {
                        alertController.dismiss(animated: true, completion: nil)
                    }
                }
            }
            .subscribe(onNext: { [weak self] shouldPop in
                // 네 클릭시 shouldPop은 true
                if shouldPop {
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.nowDateText
            .bind(to: nowDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        saveMemoButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.viewModel?.saveMemo { error in
                    if let error = error {
                        print("WriteViewController saveMemo Error: \(error.localizedDescription)")
                    } else {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }).disposed(by: disposeBag)
        
        // 현재 시간을 업데이트
        viewModel?.updateCurrentTime()
        
        // currentTimeText를 timeLabel에 바인딩
        viewModel?.currentTimeText
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 타이머를 사용하여 매 초마다 현재 시간을 업데이트
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.updateCurrentTime()
                self?.setLabel()
            })
            .disposed(by: disposeBag)
    }
    
    private func setEffect() {
        // mainViewModel이 nil이 아니고, currentWeather 값이 존재하며, "rain"을 포함하는 경우
        if let weather = mainViewModel?.currentWeather.value?.weather {
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
}
