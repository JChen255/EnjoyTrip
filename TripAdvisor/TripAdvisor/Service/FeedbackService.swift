//
//  FeedbackService.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/17/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FeedbackService {
    static let shared = FeedbackService()
    
    func submitFeedback(rating: Int, comments: String, userId: String, completion: @escaping (Error?) -> Void) {
        let feedbackData: [String: Any] = [
            "rating": rating,
            "comment": comments,
            "userId": userId
        ]
        
        let feedbacksCollection = Firestore.firestore().collection("feedbacks")
        
        feedbacksCollection.addDocument(data: feedbackData) { error in
            completion(error)
        }
    }
}

