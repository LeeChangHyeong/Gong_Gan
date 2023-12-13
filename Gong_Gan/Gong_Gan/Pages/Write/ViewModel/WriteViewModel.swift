//
//  WriteViewModel.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/12/23.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseCore
import FirebaseFirestore

class WriteViewModel {
    let nowDateText = BehaviorRelay<String>(value: "")
    let mainViewModel: MainViewModel
    
    var backgroundImage = BehaviorRelay<String?>(value: nil)
    var memoText = BehaviorRelay<String?>(value: nil)
    var location = ""
    
    // 현재 시간을나타내는 Observable 속성
    let currentTimeText = BehaviorRelay<String>(value: "")
    
    init(mainViewModel: MainViewModel) {
            Observable
                .just(Date())
                .map { date in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy.MM.dd"
                    return dateFormatter.string(from: date)
                }
                .bind(to: nowDateText)
                .disposed(by: DisposeBag())
        
            self.mainViewModel = mainViewModel
        }

    
    // 이미지 이름을 업데이트 하는 함수
    func updateBackgroundImage(_ name: String) {
        backgroundImage.accept(name)
    }
    
    func saveMemo(completion: @escaping (Error?) -> Void) {
            let uid = UserData.shared.getUserUid()
            // 새로운 UUID 생성
           let memoID = UUID().uuidString

            let data = [
                "memoID": memoID,
                "date": nowDateText.value, // nowDateText를 String으로 변환
                "memo": memoText.value, // 메모 저장
                "imageName": backgroundImage.value, // 이미지 이름 추가
                "time": currentTimeText.value, // 시간 저장
                "location": location, // 위치 정보 저장
                "weather": mainViewModel.currentWeather.value?.weather.first?.main // 날씨 데이터 저장
            ]

            let userDocumentRef = Firestore.firestore().collection("users").document(uid)

            userDocumentRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // uid에 해당하는 문서가 이미 있는 경우
                    var existingMemos = document.data()?["memos"] as? [[String: String?]] ?? []
                    existingMemos.append(data)

                    userDocumentRef.updateData(["memos": existingMemos]) { error in
                        completion(error)
                    }
                } else {
                    // uid에 해당하는 문서가 없는 경우
                    userDocumentRef.setData(["memos": [data]]) { error in
                        completion(error)
                    }
                }
            }
        }
    
    func updateCurrentTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        let currentTime = formatter.string(from: Date())
        currentTimeText.accept(currentTime)
    }
}
