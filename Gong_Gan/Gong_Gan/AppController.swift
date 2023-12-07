//
//  AppController.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/7/23.
//

import UIKit
import Firebase


// Firebase 초기화 및 로그인 상태에 따라 플로우를 담당하는 class
final class AppController {
    static let shared = AppController()
    private init() {
        FirebaseApp.configure()
        registerAuthStateDidChangeEvent()
    }
    
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    func show(in window: UIWindow) {
        self.window = window
        window.backgroundColor = .systemBackground
        window.makeKeyAndVisible()
        
//        if Auth.auth().currentUser != nil {
//            if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
//                // 최초 실행일 때 로그아웃
//                do {
//                    try Auth.auth().signOut()
//                } catch let signOutError as NSError {
//                    print("Error signing out: \(signOutError)")
//                }
//                
//                // 최초 실행 여부를 UserDefaults에 기록
//                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
//            }
//        }
        
        // 로그인이 완료된 경우에는 AuthStateDidChange 이벤트를 받아서 NotificationCenter에 의하여 자동 로그인
        if Auth.auth().currentUser == nil {
            // 로그인 완료 되지 않았을때 로그인 뷰로
            routeToLogin()
        }
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkLogin), name: .AuthStateDidChange, object: nil)
    }
    
    @objc private func checkLogin() {
        if let user = Auth.auth().currentUser {
            // 로그인 되었을때
            print("AppController -> user = \(user)")
            setHome()
        } else {
            routeToLogin()
        }
    }
    
    private func setHome() {
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        } else {
            rootViewController = UINavigationController(rootViewController: MainViewController())
        }
       
    }
    
    private func routeToLogin() {
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        } else {
            rootViewController = UINavigationController(rootViewController: LoginViewController())
        }
    }
    
    private func routeToOnBoarding() {
        rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
    }
    
}
