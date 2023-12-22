//
//  MainViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/08/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AVFoundation

class MainViewController: UIViewController {
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    var seeFirst = false
    
    // 백그라운드 터치 여부 확인
    var backGroundTap = false
    var cameraModePicker: UIPickerView!
    var rotationAngle: CGFloat! = -90  * (.pi/180)
    
    private let mainView = MainView()
    private let rainEffectView = RainEffectView()
    private let snowEffectView = SnowEffectView()
    
    private let cameraAnimationView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .black.withAlphaComponent(0.7)
        view.isHidden = true
        
        return view
    }()
    private let bottomBarView = BottomBarView()
    private let topBarView = TopBarView()
    // TODO: test중
//    let captureModesList = ["도시","방","일본","지하철","야경"]
    let captureModesList = ["1하늘", "2하늘", "3하늘", "4하늘"]
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backGroundViewTapped)))
        topBarView.rainEffectView = rainEffectView
        topBarView.snowEffectView = snowEffectView
        topBarView.viewModel = viewModel
        rainEffectView.isHidden = true
        snowEffectView.isHidden = true
        
        setCameraModePicker()
        addSubView()
        setConstraints()
        bindViewModel()
        setupSwipeGestures()
    }
    
    private func addSubView() {
        view.addSubview(rainEffectView)
        view.addSubview(snowEffectView)
        view.addSubview(topBarView)
        view.addSubview(bottomBarView)
        bottomBarView.addSubview(cameraModePicker)
        view.addSubview(cameraAnimationView)
    }
    
    private func setCameraModePicker() {
        cameraModePicker = UIPickerView()
        cameraModePicker.dataSource = self
        cameraModePicker.delegate = self
        cameraModePicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    private func setConstraints() {
        bottomBarViewConstraints()
        topBarViewConstraints()
        cameraModePickerViewConstraints()
        effectConstraints()
        
        cameraAnimationView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(topBarView.snp.bottom)
            $0.bottom.equalTo(bottomBarView.snp.top)
        })
    }
    
    private func topBarViewConstraints() {
        
        topBarView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(108)
        })
    }
    
    private func bottomBarViewConstraints() {
        
        bottomBarView.snp.makeConstraints({
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(207)
        })
    }
    
    private func cameraModePickerViewConstraints() {
        
        cameraModePicker.snp.makeConstraints({
            $0.width.equalTo(40)
            $0.height.equalTo(300)
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(bottomBarView.snp.topMargin).offset(16)
        })
        
    }
    
    private func effectConstraints() {
        rainEffectView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        snowEffectView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    // 백그라운드 터치시 topBar, bottomBar 사라지면서 backGround가 전체화면으로 보임
    @objc private func backGroundViewTapped(_ recognizer: UITapGestureRecognizer) {
        backGroundTap.toggle()
        
        if backGroundTap == true {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.topBarView.alpha = 0.0
                self.bottomBarView.alpha = 0.0
            }
            
        } else if backGroundTap == false {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                self.topBarView.alpha = 1.0
                self.bottomBarView.alpha = 1.0
            }
        }
    }
    
    private func bindViewModel() {
        bottomBarView.viewModel = viewModel
        
        viewModel.addMemoButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.addMemoButtonTapped()
            })
            .disposed(by: disposeBag)
        
        viewModel.addGalleryButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.addGalleryButtonTapped()
            })
            .disposed(by: disposeBag)
        
        
        viewModel.addSettingButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.addSettingButtonTapped()
            })
    }
    
    private func addMemoButtonTapped() {
        if seeFirst {
            showLoginModal()
        } else {
            let vc = WriteViewController()
            let mainViewModel = viewModel
            let writeViewModel = WriteViewModel(mainViewModel: mainViewModel)
            
            // WriteViewController에 WriteViewModel 인스턴스 전달
            vc.viewModel = writeViewModel
            vc.mainViewModel = mainViewModel
            
            // MainViewController의 배경 이미지 이름을 WriteViewModel에 전달
            if let selectedImageName = viewModel.selectedBackgroundImage.value {
                writeViewModel.updateBackgroundImage(selectedImageName)
            } else {
                writeViewModel.updateBackgroundImage("도시") // 기본 이미지 이름
            }
            
            playCameraSound()
            cameraAnimationView.isHidden = false
            view.isUserInteractionEnabled = false
            
            // 1초 후에 다시 숨김 후에 pushViewController 실행
            Observable.just(())
                .delay(.milliseconds(100), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    self?.cameraAnimationView.isHidden = true
                }, onCompleted: { [weak self] in
                    // 0.2초 뒤에 pushViewController 실행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self?.view.isUserInteractionEnabled = true
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func addGalleryButtonTapped() {
        
        if seeFirst {
            showLoginModal()
        } else {
            let vc = GalleryViewController()
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func addSettingButtonTapped() {
        let vc = SettingViewController()
        
        vc.seeFirst = self.seeFirst
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func playCameraSound() {
        // 실제 아이폰 카메라 소리
        AudioServicesPlaySystemSound(1108)
    }
    
    // 스와이프 제스처를 감지하기 위한 함수
    private func setupSwipeGestures() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
    
    // 스와이프 제스처 핸들러
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            // 왼쪽으로 스와이프할 때 picker를 이동시키는 동작 수행
            movePickerLeft()
        } else if gesture.direction == .right {
            // 오른쪽으로 스와이프할 때 picker를 이동시키는 동작 수행
            movePickerRight()
        }
    }
    
    // Picker를 왼쪽으로 이동시키는 함수
    private func movePickerLeft() {
        let selectedRow = cameraModePicker.selectedRow(inComponent: 0)
        let newSelectedRow = min(selectedRow + 1, captureModesList.count - 1)
        
        if selectedRow != newSelectedRow {
            UIView.animate(withDuration: 0.3) {
                self.cameraModePicker.selectRow(newSelectedRow, inComponent: 0, animated: true)
                self.pickerView(self.cameraModePicker, didSelectRow: newSelectedRow, inComponent: 0)
            }
        }
    }
    
    // Picker를 오른쪽으로 이동시키는 함수
    private func movePickerRight() {
        
        let selectedRow = cameraModePicker.selectedRow(inComponent: 0)
        let newSelectedRow = max(selectedRow - 1, 0)
        
        if selectedRow != newSelectedRow {
            UIView.animate(withDuration: 0.3) {
                self.cameraModePicker.selectRow(newSelectedRow, inComponent: 0, animated: true)
                self.pickerView(self.cameraModePicker, didSelectRow: newSelectedRow, inComponent: 0)
            }
        }
    }
}

extension MainViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return captureModesList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textColor = .white
        label.text = captureModesList[row]
        label.textAlignment = .center
        label.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))
        
        pickerView.subviews.forEach {
            $0.backgroundColor = UIColor.clear
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func showLoginModal() {
        let vc = ModalLoginViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true)
    }
}

extension MainViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedImageName = captureModesList[row]
//        mainView.backGroundView.image = UIImage(named: selectedImageName)
        mainView.name = selectedImageName
        mainView.playVideo(with: selectedImageName)
        mainView.observePlayerDidPlayToEndTime()
        // MainViewController의 배경 이미지 이름을 viewModel에 전달
//        viewModel.updateSelectedImageName(selectedImageName)
        viewModel.updateSelectedImageName(selectedImageName)
    }
}

class CustomModalPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }
        let height: CGFloat = 280
        let originY = containerView.frame.height - height
        return CGRect(x: 0, y: originY, width: containerView.frame.width, height: height)
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
