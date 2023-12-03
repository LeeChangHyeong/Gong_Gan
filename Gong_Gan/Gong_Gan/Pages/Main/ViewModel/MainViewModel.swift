//
//  MainViewModel.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/12/23.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    let addMemoButtonTapped = PublishRelay<Void>()
    let addGalleryButtonTapped = PublishRelay<Void>()
    let addSettingButtonTapped = PublishRelay<Void>()
    let selectedBackgroundImage = BehaviorRelay<String?>(value: nil)
    
    
    func updateSelectedImageName(_ name: String) {
        selectedBackgroundImage.accept(name)
        }
}
