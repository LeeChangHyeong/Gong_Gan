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

class JoinViewController: UIViewController {
    
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
        
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        setConstraints()
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
    
    
    
}
