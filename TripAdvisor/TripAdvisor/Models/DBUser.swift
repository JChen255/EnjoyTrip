//
//  DBUser.swift
//  TripAdvisor
//
//  Created by Weiqi Zhuang on 8/14/23.
//

import Foundation

struct DBUser: Codable {
    let userId: String
    let email: String?
    let photoUrl: String?
    let dateCreated: Date
    let userName: String
    
    init(auth: AuthDataResultModel, userName: String) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.userName = userName
    }
}
