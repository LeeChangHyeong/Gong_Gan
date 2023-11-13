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
    let backgroundImage = BehaviorRelay<String?>(value: nil)
    let memoText = BehaviorRelay<String?>(value: nil)
    
    // 이미지 이름을 업데이트 하는 함수
    func updateBackgroundImage(_ name: String) {
        backgroundImage.accept(name)
    }
}
