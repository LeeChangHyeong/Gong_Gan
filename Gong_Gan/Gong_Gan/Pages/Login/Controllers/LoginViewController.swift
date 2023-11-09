//
//  LoginViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/7/23.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    let viewModel = LoginViewModel()
    let isEmailValid = BehaviorSubject(value: false)
    let isPwValid = BehaviorSubject(value: false)
    let disposeBag = DisposeBag()
    // TODO: 임시로 성공할때 적는 이메일 비밀번호
    let userEmail = "shlee509@nate.com"
    let userPassword = "dlckdgud11"

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
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 6
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입하기", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        emailTf.text = ""
        passWordTf.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        setConstraints()
        setupControl()
    }
    
    private func addViews() {
        view.addSubview(emailTf)
        view.addSubview(passWordTf)
        view.addSubview(loginButton)
        view.addSubview(joinButton)
    }
    
    private func setConstraints() {
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
        
        loginButton.snp.makeConstraints({
            $0.top.equalTo(passWordTf.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        })
        
        joinButton.snp.makeConstraints({
            $0.top.equalTo(loginButton.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        })
    }
    
    private func setupControl() {
        // 이메일 입력 textField를 viewModel의 emialObserver로 바인딩
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
        
        // TODO: FireBase 서버에 등록된 아이디인지 확인하여 로그인 성공 시키고 실패시키는 로직으로 리팩토링 필요
        loginButton.rx.tap.subscribe (onNext: { [weak self] _ in
            if self?.userEmail == self?.viewModel.emailObserver.value && self?.userPassword == self?.viewModel.passwordObserver.value {
                let alert = UIAlertController(title: "로그인 성공", message: "하이", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                alert.addAction(ok)
                self?.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "로그인 실패", message: "이메일 비번 다시 확인부탁", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                alert.addAction(ok)
                self?.present(alert, animated: true, completion: nil)
            }
        })
        .disposed(by: disposeBag)
    }
    
    @objc private func joinButtonTapped() {
        let vc = JoinViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
