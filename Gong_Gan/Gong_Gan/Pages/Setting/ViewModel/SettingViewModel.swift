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
}
