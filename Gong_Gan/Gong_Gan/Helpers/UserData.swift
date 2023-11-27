//
//  UserData.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/27/23.
//

import FirebaseAuth

struct UserData {
    static let shared = UserData()
    
    func getUserUid() -> String {
        var userUid = ""
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            
            return uid
        }
        
        return ""
    }
}
