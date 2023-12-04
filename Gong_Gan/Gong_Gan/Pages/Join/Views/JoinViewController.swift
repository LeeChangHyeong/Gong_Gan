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
    
    private let emailTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이메일을 입력해주세요"
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    private let passWordTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비밀번호를 입력해주세요"
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    private let joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 6
        button.isEnabled = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        setConstraints()
        setupControl()
    }
    
    func addViews() {
        view.addSubview(emailTf)
        view.addSubview(passWordTf)
        view.addSubview(joinButton)
    }
    
    func setConstraints() {
        emailTf.snp.makeConstraints({
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        })
        
        passWordTf.snp.makeConstraints({
            $0.top.equalTo(emailTf.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        })
        
        joinButton.snp.makeConstraints({
            $0.top.equalTo(passWordTf.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        })
    }
    
    private func setupControl() {
        emailTf.rx.text
            .orEmpty
            .bind(to: viewModel.emailObserver)
            .disposed(by: disposeBag)
        
        passWordTf.rx.text
            .orEmpty
            .bind(to: viewModel.passwordObserver)
            .disposed(by: disposeBag)
        
        viewModel.isValid.bind(to: joinButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .map{$0 ? 1: 0.3}
            .bind(to: joinButton.rx.alpha)
            .disposed(by: disposeBag)
        
        // TODO: 회원가입 버튼 클릭시 실제로 회원가입 되고 MainView로 넘어가게 구현 해야함
        joinButton.rx.tap.subscribe(onNext: { [weak self] _ in
            
            guard let email = self?.emailTf.text else { return }
            guard let password = self?.passWordTf.text else { return }

            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("JoinViewController 회원가입 에러 -> \(error.localizedDescription)")
                }
                
                let data = ["email": email,
                            "displayName": "our"]
                
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
