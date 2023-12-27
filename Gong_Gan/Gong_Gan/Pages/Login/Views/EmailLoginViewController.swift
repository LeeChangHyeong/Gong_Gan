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
        tf.layer.cornerRadius = 8
        tf.backgroundColor = .settingCellColor
        tf.textColor = .white
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: tf.frame.height))
        tf.leftView = leftPaddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .brandColor
        button.layer.cornerRadius = 6
        button.isEnabled = false
        
        return button
    }()
    
    private let passWordTf: UITextField = {
        let tf = UITextField()
        // placeholder의 색을 변경하기 위한 NSAttributedString 생성
        let placeholderText = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeHolderColor])
        tf.attributedPlaceholder = placeholderText
        tf.layer.cornerRadius = 8
        tf.backgroundColor = .settingCellColor
        tf.textColor = .white
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: tf.frame.height))
        tf.leftView = leftPaddingView
        tf.leftViewMode = .always
        
        // Secure Text Entry를 사용하여 비밀번호를 가림
        tf.isSecureTextEntry = true
        
        // 비밀번호 볼 수 있도록 하는 버튼
        let showHideButton = UIButton(type: .custom)
        
        showHideButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        showHideButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        showHideButton.tintColor = UIColor.systemGray
        showHideButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        tf.rightView = showHideButton
        tf.rightViewMode = .always
        
        return tf
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일로 로그인"
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        
        return label
    }()
    
    private let loginFailLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "exclamationmark.circle")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        
        let attributedString = NSMutableAttributedString(attachment: attachment)
        
        attributedString.append(NSAttributedString(string: " 이메일과 비밀번호를 다시 확인해주세요.", attributes: [
            .foregroundColor: UIColor.red,
            .font: UIFont.systemFont(ofSize: 13, weight: .bold)
        ]))
        
        label.attributedText = attributedString
        
        return label
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.backgroundColor = .mainBackGroundColor
        emailTf.text = ""
        passWordTf.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackGroundColor
        setNaviBar()
        addViews()
        setConstraints()
        setupControl()
    }
    
    private func addViews() {
        view.addSubview(emailTf)
        view.addSubview(passWordTf)
        view.addSubview(loginButton)
        view.addSubview(loginFailLabel)
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
        
        loginFailLabel.snp.makeConstraints({
            $0.top.equalTo(passWordTf.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
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
        
        emailTf.rx.controlEvent([.editingDidBegin,.editingChanged])
            .subscribe(onNext: { [weak self] _ in
                self?.loginFailLabel.isHidden = true
            })
            .disposed(by: disposeBag)
        
        passWordTf.rx.controlEvent([.editingDidBegin,.editingChanged])
            .subscribe(onNext: { [weak self] _ in
                self?.loginFailLabel.isHidden = true
            })
            .disposed(by: disposeBag)
        
        loginButton.rx.tap.subscribe (onNext: { [weak self] _ in
            guard let email = self?.emailTf.text else { return }
            guard let password = self?.passWordTf.text else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) {
                [self] authResult, error in
                if authResult == nil {
                    if let errorCode = error {
                        print(errorCode)
                        self?.loginFailLabel.isHidden = false
                        
                    }
                } else if authResult != nil {
                    
                }
            }
        })
        .disposed(by: disposeBag)
    }
    
    @objc private func togglePasswordVisibility() {
        // "비밀번호 보이기" 버튼을 토글하여 Secure Text Entry를 업데이트
        passWordTf.isSecureTextEntry.toggle()
        
        // 버튼 이미지 변경
        let imageName = passWordTf.isSecureTextEntry ? "eye.slash" : "eye"
        if let button = passWordTf.rightView as? UIButton {
            button.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
}
