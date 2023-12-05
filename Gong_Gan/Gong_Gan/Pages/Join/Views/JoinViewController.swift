//
//  JoinViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/7/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class JoinViewController: UIViewController {
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    private let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        button.setImage(image, for: .normal)
        
        button.tintColor = .white
        
        return button
    }()
    
    private let joinLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일로 회원가입하기"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private let emailTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이메일을 입력해주세요"
        tf.layer.cornerRadius = 8
        tf.backgroundColor = .joinTextFieldColor
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: tf.frame.height))
        tf.leftView = leftPaddingView
        tf.leftViewMode = .always
        
        tf.keyboardType = .emailAddress
        
        return tf
    }()
    
    private let emailVaildErrorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "exclamationmark.circle")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        
        let attributedString = NSMutableAttributedString(attachment: attachment)
        
        attributedString.append(NSAttributedString(string: " 이미 존재하는 이메일입니다.", attributes: [
            .foregroundColor: UIColor.red,
            .font: UIFont.systemFont(ofSize: 13, weight: .bold)
        ]))
        
        label.attributedText = attributedString
        
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private let passWordTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비밀번호를 입력해주세요"
        tf.layer.cornerRadius = 8
        tf.backgroundColor = .joinTextFieldColor
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: tf.frame.height))
        tf.leftView = leftPaddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    private let joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("가입완료", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .joinButtonColor
        button.layer.cornerRadius = 6
        button.isEnabled = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .galleryColor
        addViews()
        setConstraints()
        setupControl()
        setNaviBar()
        setJoinButton()
    }
    
    private func setNaviBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func addViews() {
        view.addSubview(joinLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTf)
        view.addSubview(emailVaildErrorLabel)
        view.addSubview(passwordLabel)
        view.addSubview(passWordTf)
        view.addSubview(joinButton)
    }
    
    private func setConstraints() {
        joinLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(20)
        })
        
        emailLabel.snp.makeConstraints({
            $0.top.equalTo(joinLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
        })
        
        emailTf.snp.makeConstraints({
            $0.top.equalTo(emailLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(49)
        })
        
        emailVaildErrorLabel.snp.makeConstraints({
            $0.top.equalTo(emailTf.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
        })
        
        passwordLabel.snp.makeConstraints({
            $0.top.equalTo(emailTf.snp.bottom).offset(48)
            $0.leading.equalToSuperview().offset(20)
        })
        
        passWordTf.snp.makeConstraints({
            $0.top.equalTo(passwordLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(49)
        })
        
        joinButton.snp.makeConstraints({
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
        })
    }
    
    private func setJoinButton() {
        // 키보드의 올라오는 이벤트를 감지하여 높이를 가져오는 Observable
        let keyboardWillShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                    return 0
                }
                return keyboardFrame.cgRectValue.height
            }
        
        // 키보드의 내려가는 이벤트를 감지하여 높이를 가져오는 Observable
        let keyboardWillHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in
                return 0
            }
        
        // 올라오는 이벤트와 내려가는 이벤트를 합침
        let keyboardHeightObservable = Observable.merge(keyboardWillShowObservable, keyboardWillHideObservable)
        
        // Join button의 bottom constraint을 키보드의 높이에 따라 업데이트
        keyboardHeightObservable
            .subscribe(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                self.joinButton.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20 - keyboardHeight)
                }
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupControl() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        emailTf.rx.text
            .orEmpty
            .bind(to: viewModel.emailObserver)
            .disposed(by: disposeBag)
        
        passWordTf.rx.text
            .orEmpty
            .bind(to: viewModel.passwordObserver)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .bind(to: joinButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .map{$0 ? 1: 0.3}
            .bind(to: joinButton.rx.alpha)
            .disposed(by: disposeBag)
        
        emailTf.rx.controlEvent([.editingDidBegin, .editingChanged])
            .subscribe(onNext: { [weak self] _ in
                self?.emailVaildErrorLabel.isHidden = true
            })
            .disposed(by: disposeBag)
        
        joinButton.rx.tap.subscribe(onNext: { [weak self] _ in
            
            guard let email = self?.emailTf.text else { return }
            guard let password = self?.passWordTf.text else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("JoinViewController 회원가입 에러 -> \(error.localizedDescription)")
                    
                    if error.localizedDescription == "The email address is already in use by another account." {
                        self?.emailVaildErrorLabel.isHidden = false
                    }
                }
                let data = ["email": email,
                            "platform": "our"]
                
                // 파이어베이스 유저 객체를 가져옴
                guard let user = result?.user else { return }
                
                // 가입에 성공하면 그 유저의 uid를 파이어베이스가 생성
                // 이 uid를 기준으로 특정한 유저 데이터를 저장
                Firestore.firestore().collection("users").document(user.uid).setData(data) { error in
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                        return
                    }
                }
            }
        })
    }
    
    
    //    private func setupControl() {
    //        // 이메일 입력 textField를 viewModel의 emialObserver로 바인딩
    //        emailTf.rx.text
    //            .orEmpty
    //            .bind(to: viewModel.emailObserver)
    //            .disposed(by: disposeBag)
    //        // 비밀번호 입력 textField를 viewModel의 passwordObserver로 바인딩
    //        passWordTf.rx.text
    //            .orEmpty
    //            .bind(to: viewModel.passwordObserver)
    //            .disposed(by: disposeBag)
    //
    //        // viewModel에서 입력한 값을 통해 로그인 버튼의 enabled를 정해줌
    //        viewModel.isValid.bind(to: loginButton.rx.isEnabled)
    //            .disposed(by: disposeBag)
    //
    //        // 시각적으로 버튼이 활성화, 비활성화 되었는지 보여주기 위해 alpha값을 줌
    //        viewModel.isValid
    //            .map{$0 ? 1 : 0.3}
    //            .bind(to: loginButton.rx.alpha)
    //            .disposed(by: disposeBag)
    //
    //        // TODO: FireBase 서버에 등록된 아이디인지 확인하여 로그인 성공 시키고 실패시키는 로직으로 리팩토링 필요
    //        loginButton.rx.tap.subscribe (onNext: { [weak self] _ in
    //            if self?.userEmail == self?.viewModel.emailObserver.value && self?.userPassword == self?.viewModel.passwordObserver.value {
    //                let alert = UIAlertController(title: "로그인 성공", message: "하이", preferredStyle: .alert)
    //                let ok = UIAlertAction(title: "확인", style: .default)
    //                alert.addAction(ok)
    //                self?.present(alert, animated: true, completion: nil)
    //            } else {
    //                let alert = UIAlertController(title: "로그인 실패", message: "이메일 비번 다시 확인부탁", preferredStyle: .alert)
    //                let ok = UIAlertAction(title: "확인", style: .default)
    //                alert.addAction(ok)
    //                self?.present(alert, animated: true, completion: nil)
    //            }
    //        })
    //        .disposed(by: disposeBag)
    //    }
    
}
