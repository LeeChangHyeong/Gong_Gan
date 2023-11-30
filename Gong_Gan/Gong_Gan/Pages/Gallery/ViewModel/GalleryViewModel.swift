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
    let galleryData = BehaviorRelay<[GalleryDataModel]>(value: [])
    
    func fetchGalleryData() {
        let uid = UserData.shared.getUserUid()
        let userDocumentRef = Firestore.firestore().collection("users").document(uid)
        
        userDocumentRef.getDocument { document, error in
            if let document = document, document.exists {
                if let memosArray = document["memos"] as? [[String: Any]] {
                    
                    print(memosArray)
                    
                    let reversedMemosArray = memosArray.reversed()
                    // 모든 데이터를 저장할 배열 초기화
                    var galleryDataArray: [GalleryDataModel] = []
                    
                    for memoDict in reversedMemosArray {
                        guard
                            let memoID = memoDict["memoID"] as?
                                String,
                            let date = memoDict["date"] as? String,
                            let imageName = memoDict["imageName"] as? String,
                            let location = memoDict["location"] as? String,
                            let memo = memoDict["memo"] as? String,
                            let time = memoDict["time"] as? String
                        else {
                            continue
                        }
                        
                        // 모든 데이터를 GalleryDataModel로 만들어 배열에 저장
                        let galleryData = GalleryDataModel(memoID: memoID, date: date, imageName: imageName, location: location, memo: memo, time: time)
                        galleryDataArray.append(galleryData)
                    }
                    
                    // galleryData에 데이터 저장
                    self.galleryData.accept(galleryDataArray)
                    
                    print("Gallery data array: \(galleryDataArray)")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
}
