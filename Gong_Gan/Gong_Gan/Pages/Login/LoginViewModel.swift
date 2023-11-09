//
//  LoginViewModel.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/9/23.
//

import Foundation
import RxSwift
import RxRelay

class LoginViewModel {
    // LoginViewController의 이메일 TextField와 비밀번호 TextField를 받아온다
    let emailObserver = BehaviorRelay<String>(value: "")
    let passwordObserver = BehaviorRelay<String>(value: "")
    
    // 사용자가 값을 입력할때마다 emailObserver, passwordObserver의 가장 마지막 값들을 내보내고
    // 밑의 조건문으로 입력을 체크해준다
    var isValid: Observable<Bool> {
        return Observable.combineLatest(emailObserver, passwordObserver)
            .map{ email, password in
                    print("\(email),  \(password)")
                return !email.isEmpty && email.contains("@") && email.contains(".") && password.count > 0
            }
    }
}
