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
    private let disposeBag = DisposeBag()
    private var locationManager = CLLocationManager()
    
    var viewModel: WriteViewModel?
    var backgroundImage: UIImage?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let locationSubject = PublishSubject<CLLocation>()
    
    private let textViewColor: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        return view
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
        setupControl()
        setLocationManager()
        bindToLocationUpdate()
        setupSwipeGesture()
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
        navigationItem.titleView = nowDateLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveMemoButton)
    }
    
    private func setConstraints() {
        
        textViewColor.snp.makeConstraints({
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
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func bindToLocationUpdate() {
        locationSubject
        // 한 번만 실행
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self ] location in
                CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                    if let place = placemarks?.first {
                        let attributedString = NSMutableAttributedString(string: "")
                        let imageAttachment = NSTextAttachment()
                        
                        let locationImage = UIImage(named: "location")?.withTintColor(.white.withAlphaComponent(0.75))
                        imageAttachment.image = locationImage
                        attributedString.append(NSAttributedString(attachment: imageAttachment))
                        
                        let textAttributes: [NSAttributedString.Key: Any] = [
                            .font: UIFont.systemFont(ofSize: 15, weight: .bold),
                            .foregroundColor: UIColor.white.withAlphaComponent(0.75)
                        ]
                        
                        attributedString.append(NSAttributedString(string: " \(place.locality ?? "") \(place.subLocality ?? "")", attributes: textAttributes))
                        
                        self?.locationLabel.attributedText = attributedString
                        
                        self?.viewModel?.location = " \(place.locality ?? "") \(place.subLocality ?? "")"
                        
                        // 위치를 가지고 왔으면 업데이트 중지
                        self?.locationManager.stopUpdatingLocation()
                        
                    }
                }
            })
            .disposed(by: disposeBag)
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
            })
            .disposed(by: disposeBag)
    }
}


extension WriteViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationSubject.onNext(location)
        }
    }
}
