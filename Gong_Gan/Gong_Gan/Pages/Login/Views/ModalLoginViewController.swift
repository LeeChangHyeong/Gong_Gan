//
//  ModalLoginViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/11/23.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseCore
import AuthenticationServices
import FirebaseFirestoreInternal
import CryptoKit

class ModalLoginViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인 / 회원가입"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        button.setImage(image, for: .normal)
        
        button.tintColor = .white
        
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apple로 로그인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.layer.cornerRadius = 25
        button.backgroundColor = .black
        
        // 이미지 설정
        if let appleImage = UIImage(named: "apple") {
            button.setImage(appleImage, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -150, bottom: 0, right: 0)
        }
        
        // titleLabel 중앙에 위치시키기
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -button.imageView!.frame.size.width, bottom: 0, right: 0)
        
        // 1포인트 흰색 테두리 추가
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    private let emailLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("이메일로 회원가입하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.backgroundColor = .emailLoginButtonColor
        button.layer.cornerRadius = 25
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackGroundColor
        view.layer.cornerRadius = 20
        addViews()
        setConstraints()
        setControls()

        // Do any additional setup after loading the view.
    }
    
    private func addViews() {
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(appleLoginButton)
        view.addSubview(emailLoginButton)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(35)
            $0.leading.equalToSuperview().offset(20)
        })
        
        closeButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(35)
            $0.trailing.equalToSuperview().offset(-20)
        })
        
        appleLoginButton.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
        })
        
        emailLoginButton.snp.makeConstraints({
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
        })
    }
    
    private func setControls() {
        closeButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            })
        
        appleLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.startSignInWithAppleFlow()
            })
            .disposed(by: disposeBag)
        
        emailLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = JoinViewController()
                
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate var currentNonce: String?
    
    @objc func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
}

@available(iOS 13.0, *)
extension ModalLoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription ?? "")
                    return
                }
                guard let user = authResult?.user else { return }
                let email = user.email ?? ""
                let loginName = "Apple"
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let db = Firestore.firestore()
                db.collection("users").document(uid).setData([
                    "email": email,
                    "platform": loginName
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("the user has sign up or is logged in")
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension ModalLoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
