//
//  SettingViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/2/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import CoreLocation

class SettingViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var seeFirst = false
    
    private let myInfoView = MyInfoView()
    private let locationSettingView = LocationSettingView()
    private let versionView = VersionView()
    private let inquriyView = InquiryView()
    
    private let viewModel = SettingViewModel()
    
    private let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        button.setImage(image, for: .normal)
        
        button.tintColor = .white
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "설정"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackGroundColor
        setNaviBar()
        addSubView()
        setConstraints()
        setupControl()
        
        setupNotificationObserver()
    }
    
    deinit {
        // NotificationCenter에서 등록한 옵저버를 해제
        // 메모리 누수 방지
        removeNotificationObserver()
    }
    
    private func setNaviBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.titleView = titleLabel
    }
    
    private func addSubView() {
        view.addSubview(myInfoView)
        view.addSubview(locationSettingView)
        view.addSubview(versionView)
        view.addSubview(inquriyView)
    }
    
    private func setConstraints() {
        myInfoView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.height.equalTo(50)
        })
        
        locationSettingView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(myInfoView.snp.bottom).offset(8)
            $0.height.equalTo(50)
        })
        
        versionView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(locationSettingView.snp.bottom).offset(40)
            $0.height.equalTo(50)
        })
        
        inquriyView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(versionView.snp.bottom).offset(8)
            $0.height.equalTo(50)
        })
    }
    
    private func setupControl() {
        backButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        // ViewModel과 ViewController를 바인딩
        viewModel.locationPermissionEnabled
            .drive(onNext: { [weak self] isEnabled in
                // LocationSettingView에서 switch 상태를 업데이트
                self?.locationSettingView.setSwitchState(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
        
        // viewWillAppear 이벤트를 ViewModel로 전달
        rx.sentMessage(#selector(viewWillAppear(_:)))
            .map { _ in }
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
    }
    
    @objc private func handleMyInfoViewTap() {
        // MyInfoView가 탭되었을 때 수행할 동작을 여기에 추가
        if seeFirst {
            showLoginModal()
        } else {
            let myInfoVC = MyInfoViewController()
            
            navigationController?.pushViewController(myInfoVC, animated: true)
        }
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleMyInfoViewTap), name: Notification.Name("MyInfoViewTapped"), object: nil)
    }
    
    private func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showLoginModal() {
        let vc = ModalLoginViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true)
    }
}


extension SettingViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
