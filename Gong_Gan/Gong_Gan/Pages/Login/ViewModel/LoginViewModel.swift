//
//  LoginViewModel.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/9/23.
//

import Foundation
import RxSwift
import RxRelay
import AuthenticationServices

class LoginViewModel {
    // LoginViewController의 이메일 TextField와 비밀번호 TextField를 받아온다
    let emailObserver = BehaviorRelay<String>(value: "")
    let passwordObserver = BehaviorRelay<String>(value: "")
    
    // 사용자가 값을 입력할때마다 emailObserver, passwordObserver의 가장 마지막 값들을 내보내고
    // 밑의 조건문으로 입력을 체크해준다
    var isValid: Observable<Bool> {
        return Observable.combineLatest(emailObserver, passwordObserver)
            .map{ email, password in
                print("LoginViewModel -> 아이디 비밀번호 입력중: \(email),  \(password)")
                return self.isValidEmail(email) && self.isValidPassword(password)
            }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        return password.count > 5
    }
}
