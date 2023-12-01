//
//  ReadViewModel.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/30/23.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

class ReadViewModel {
    private let disposeBag = DisposeBag()
    
    let selectedGalleryData = BehaviorRelay<GalleryDataModel?>(value: nil)
    
    // 초기화 및 선택된 데이터 설정
    init(selectedGalleryData: GalleryDataModel?) {
        self.selectedGalleryData.accept(selectedGalleryData)
    }
    
    // Firebase에서 메모 삭제
    func deleteMemo(completion: @escaping (Error?) -> Void) {
        guard let memoID = selectedGalleryData.value?.memoID else {
            // memoID가 없을 경우 처리
            return
        }

        let uid = UserData.shared.getUserUid()
        let userDocumentRef = Firestore.firestore().collection("users").document(uid)

        userDocumentRef.getDocument { document, error in
            if let document = document, document.exists {
                var existingMemos = document.data()?["memos"] as? [[String: Any]] ?? []

                // 해당 memoID와 일치하는 메모를 찾아 삭제
                existingMemos.removeAll { $0["memoID"] as? String == memoID }

                userDocumentRef.updateData(["memos": existingMemos]) { error in
                    completion(error)
                }
            }
        }
    }
    
    func updateMemo(newMemo: String, completion: @escaping (Error?) -> Void) {
        guard let memoID = selectedGalleryData.value?.memoID else {
            return
        }
        
        let uid = UserData.shared.getUserUid()
        let userDocumentRef = Firestore.firestore().collection("users").document(uid)
        
        userDocumentRef.getDocument { document, error in
            if let document = document, document.exists {
                var existingMemos = document.data()?["memos"] as? [[String: Any]] ?? []
                
            // 해당 memoID와 일치하는 메모를 찾아 업데이트
                if let index = existingMemos.firstIndex(where: {$0["memoID"] as? String == memoID}) {
                    existingMemos[index]["memo"] = newMemo
                }
                
                userDocumentRef.updateData(["memos": existingMemos]) { error in
                        completion(error)
                }
            }
        }
    }
}
