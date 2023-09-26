//
//  ProfileModel.swift
//  TripAdvisor
//
//  Created by wade hu on 8/16/23.
//

import Foundation

struct Profile: Codable {
    let userId: String
    var photoUrl: String?
    var reviewList:[String]?
    var name: String
    
    init(userId: String, photoUrl: String?, reviewList: [String]?, name:String) {
        self.userId = userId
        self.photoUrl = photoUrl
        self.reviewList = reviewList
        self.name = name
    }
    
    init(user: DBUser) {
        self.userId = user.userId
        self.name = user.userName
        self.reviewList = []
        // TODO: get default from database?
        self.photoUrl = "photo.circle"
    }
}
