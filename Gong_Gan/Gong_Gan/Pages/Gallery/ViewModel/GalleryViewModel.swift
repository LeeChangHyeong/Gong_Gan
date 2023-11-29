//
//  GalleryViewModel.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/28/23.
//

import FirebaseFirestore
import RxSwift
import RxCocoa

class GalleryViewModel {
    let galleryImageNames = BehaviorRelay<[String]>(value: [])
    
    func fetchGalleryData() {
        let uid = UserData.shared.getUserUid()
        let userDocumentRef = Firestore.firestore().collection("users").document(uid)
        
        
        userDocumentRef.getDocument { document, error in
            if let document = document, document.exists {
                // "memos" 필드의 값이 배열인 경우, 각 문서에서 "imageName" 값을 추출하여 배열에 저장
                if let memosArray = document["memos"] as? [[String: Any]] {
                    let imageNamesArray = memosArray.compactMap { $0["imageName"] as? String }
                    
                    // galleryImageNames에 최신 일기가 앞에 오도록 저장
                    let reversedArray = imageNamesArray.reversed()
                    self.galleryImageNames.accept(Array(reversedArray))
                    
                    print("Image names array: \(imageNamesArray)")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}
