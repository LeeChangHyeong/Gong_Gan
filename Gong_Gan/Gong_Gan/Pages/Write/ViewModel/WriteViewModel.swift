//
//  WriteViewModel.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/12/23.
//

import Foundation
import RxSwift
import RxCocoa

class WriteViewModel {
    // Outputs
    let nowDateText: Driver<String>
    
    // Inputs
    var backgroundImage = BehaviorRelay<String?>(value: nil)
    var memoText = BehaviorRelay<String?>(value: nil)
    
    init() {
        nowDateText = Observable
            .just(Date())
            .map{ date in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                return dateFormatter.string(from: date)
            }
            .asDriver(onErrorJustReturn: "")
        
        backgroundImage = BehaviorRelay<String?>(value: nil)
        memoText = BehaviorRelay<String?>(value: nil)
    }
    
    // 이미지 이름을 업데이트 하는 함수
    func updateBackgroundImage(_ name: String) {
        backgroundImage.accept(name)
    }
}
