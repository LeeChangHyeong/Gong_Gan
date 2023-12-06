//
//  EmailLoginViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/6/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class EmailLoginViewController: UIViewController {
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    let isEmailValid = BehaviorSubject(value: false)
    let isPwValid = BehaviorSubject(value: false)

    private let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        button.setImage(image, for: .normal)
        
        button.tintColor = .white
        
        return button
    }()
    
    private let emailTf: UITextField = {
        let tf = UITextField()
        // placeholder의 색을 변경하기 위한 NSAttributedString 생성
        let placeholderText = NSAttributedString(string: "이메일", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeHolderColor])
        tf.attributedPlaceholder = placeholderText
            tf.borderStyle = .roundedRect
            tf.backgroundColor = .settingCellColor
        tf.textColor = .white
        
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .galleryLabelColor
        button.layer.cornerRadius = 6
        button.isEnabled = false
        
        return button
    }()
    
    private let passWordTf: UITextField = {
        let tf = UITextField()
        // placeholder의 색을 변경하기 위한 NSAttributedString 생성
        let placeholderText = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeHolderColor])
        tf.attributedPlaceholder = placeholderText
            tf.borderStyle = .roundedRect
            tf.backgroundColor = .settingCellColor
        tf.textColor = .white
        
        return tf
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일로 로그인"
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        
        return label
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        emailTf.text = ""
        passWordTf.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .galleryColor
        setNaviBar()
        addViews()
        setConstraints()
        setupControl()
    }
    
    private func addViews() {
        view.addSubview(emailTf)
        view.addSubview(passWordTf)
        view.addSubview(loginButton)
    }
    
    private func setConstraints() {
        emailTf.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(49)
        })
        
        passWordTf.snp.makeConstraints({
            $0.top.equalTo(emailTf.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(49)
        })
        
        loginButton.snp.makeConstraints({
            $0.top.equalTo(passWordTf.snp.bottom).offset(48)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
        })
    }
    
    private func setNaviBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.titleView = titleLabel
    }
    
    
    private func setupControl() {
        backButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        // 이메일 입력 textField를 viewModel의 emailObserver로 바인딩
        emailTf.rx.text
            .orEmpty
            .bind(to: viewModel.emailObserver)
            .disposed(by: disposeBag)
        // 비밀번호 입력 textField를 viewModel의 passwordObserver로 바인딩
        passWordTf.rx.text
            .orEmpty
            .bind(to: viewModel.passwordObserver)
            .disposed(by: disposeBag)
        
        // viewModel에서 입력한 값을 통해 로그인 버튼의 enabled를 정해줌
        viewModel.isValid.bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 시각적으로 버튼이 활성화, 비활성화 되었는지 보여주기 위해 alpha값을 줌
        viewModel.isValid
            .map{$0 ? 1 : 0.3}
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap.subscribe (onNext: { [weak self] _ in
            guard let email = self?.emailTf.text else { return }
            guard let password = self?.passWordTf.text else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) {
                [self] authResult, error in
                if authResult == nil {
                    if let errorCode = error {
                        print(errorCode)
                    }
                } else if authResult != nil {
                    
                }
            }
        })
        .disposed(by: disposeBag)
    }
}
