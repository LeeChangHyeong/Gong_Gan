//
//  MyInfoViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/5/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import KakaoSDKUser

class MyInfoViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = SettingViewModel()
    private let logOutView = LogOutView()
    private let withdrawalView = WithdrawalView()
    
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
        label.text = "내 정보"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "계정"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .galleryLabelColor
        label.text = ""
        label.font = .systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .galleryColor
        setNaviBar()
        addSubViews()
        setConstraints()
        setupControl()
        setupNotificationObserver()
    }
    
    private func setNaviBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.titleView = titleLabel
    }
    
    private func addSubViews() {
        view.addSubview(accountLabel)
        view.addSubview(emailLabel)
        view.addSubview(logOutView)
        view.addSubview(withdrawalView)
    }
    
    private func setConstraints() {
        accountLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(32)
        })
        
        emailLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.trailing.equalToSuperview().offset(-32)
        })
        
        logOutView.snp.makeConstraints({
            $0.top.equalTo(accountLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        })
        
        withdrawalView.snp.makeConstraints({
            $0.top.equalTo(logOutView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        })
    }
    
    private func setupControl() {
        backButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchUserEmail()
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { [weak self] email in
                        self?.emailLabel.text = email
                    }, onError: { error in
                        self.emailLabel.text = "불러오는 중 오류 발생"
                    })
                    .disposed(by: disposeBag)
    }
    
    @objc private func handleLogOutViewTap() {
        let alertController = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        let logOutAction = UIAlertAction(title: "로그아웃", style: .destructive) {_ in
            // 카카오톡 로그아웃
            UserApi.shared.logout { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("로그아웃 성공")
                }
            }
            
            // firebase에서 지원하는 플랫폼 로그아웃
            let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                    }
        }
        
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(logOutAction)

            present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleWithdrawalViewTap() {
        let alertController = UIAlertController(title: "회원탈퇴", message: "정말 회원탈퇴하시겠습니까?", preferredStyle: .alert)
        
        let withdrawalAction = UIAlertAction(title: "회원탈퇴", style: .destructive) { _ in
            
            let uid = UserData.shared.getUserUid()
            print(uid)
            let userDocumentRef = Firestore.firestore().collection("users").document(uid)
            
            // 회원탈퇴 로직
            if let currentUser = Auth.auth().currentUser {
                currentUser.delete { error in
                    if let error = error {
                        print("회원탈퇴 에러: \(error.localizedDescription)")
                    } else {
                        print("회원탈퇴 성공")
                        // 회원 탈퇴 성공시 데이터 삭제
                        userDocumentRef.delete { error in
                            if let error = error {
                                print("문서 삭제 에러: \(error.localizedDescription)")
                            } else {
                                print("문서 데이터 삭제 성공")
                            }
                        }
                    }
                }
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(withdrawalAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogOutViewTap), name: Notification.Name("LogOutViewTapped"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleWithdrawalViewTap), name: Notification.Name("WithdrawalViewTapped"), object: nil)
    }

}
