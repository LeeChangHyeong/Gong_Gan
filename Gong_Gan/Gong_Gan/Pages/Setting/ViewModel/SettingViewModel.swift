//
//  SettingViewModel.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/4/23.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class SettingViewModel {
    let viewWillAppear = PublishSubject<Void>()
    let locationPermissionEnabled: Driver<Bool>
    
    private let disposeBag = DisposeBag()
    
    init() {
        // 이벤트를 감지하여 위치 권한을 업데이트
        locationPermissionEnabled = Observable.merge(
            viewWillAppear.map { _ in },
            NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).map { _ in }
        )
        .map { _ in
            return CLLocationManager.authorizationStatus() != .denied && CLLocationManager.authorizationStatus() != .restricted
        }
        .asDriver(onErrorJustReturn: false)
    }
    
    func fetchUserEmail() -> Observable<String> {
            return Observable.create { observer in
                let uid = UserData.shared.getUserUid()
                let userDocumentRef = Firestore.firestore().collection("users").document(uid)

                userDocumentRef.getDocument { (document, error) in
                    if let document = document, document.exists, let data = document.data(),
                        let email = data["email"] as? String {
                        observer.onNext(email)
                    } else {
                        observer.onError(NSError(domain: "UserData", code: 1, userInfo: nil))
                    }
                    observer.onCompleted()
                }

                return Disposables.create()
            }
        }
}
