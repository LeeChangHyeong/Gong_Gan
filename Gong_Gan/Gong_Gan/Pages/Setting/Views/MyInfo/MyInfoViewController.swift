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

class MyInfoViewController: UIViewController {
    private let disposeBag = DisposeBag()
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
//        checkEmail()
    }
    
    private func setNaviBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.titleView = titleLabel
    }
    
    private func addSubViews() {
        view.addSubview(accountLabel)
        view.addSubview(emailLabel)
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
    
    private func checkEmail() {
        let uid = UserData.shared.getUserUid()
        let userDocumentRef = Firestore.firestore().collection("users").document(uid)
        
        userDocumentRef.getDocument { [weak self] (document, error) in
            guard let self = self, let document = document, document.exists, let data = document.data()
            else {
                // 처리 중에 오류가 발생하거나 데이터가 없을 경우
                return
            }
            
            if let email = data["email"] as? String {
                self.emailLabel.text = email
            }
        }
    }

}
