//
//  ReviewService.swift
//  TripAdvisor
//
//  Created by Weiqi Zhuang on 8/15/23.
//

import Foundation
import FirebaseFirestore

final class ReviewService {
    
    static let shared = ReviewService()
    private init() { }
    
    static func generatedId() -> String {
        return reviewCollection.document().documentID
    }
    
    static func getAllReivews() async throws -> [Review]? {
        let snapshot = try await reviewCollection.getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: Review.self)
        }
    }
    
    static func getReviewByRef(reviewRef: DocumentReference) async throws -> Review? {
        let document = try await reviewRef.getDocument()
        
        return try? document.data(as: Review.self)
    }
    
    static func getReviewById(reviewId: String) async throws -> Review? {
        let document = try await reviewCollection.document(reviewId).getDocument()
        
        return try? document.data(as: Review.self)
    }
    
    static func getReviewsByUserId(userId: String) async throws -> [Review] {
        let snapshot = try await reviewCollection.whereField("user_id", isEqualTo: userId).getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: Review.self)
        }
    }
    
    static func createReview(author:String, comment:String, id:String, rating:Int, destinationID:String, userID:String, review_title:String, destination_name:String) async throws -> String{
        let currentDate = Date()
        let timeStamp = Timestamp(date: currentDate)
        let docRef = reviewCollection.document(id)
        try await docRef.setData(["author": author, "comment": comment, "id": id, "rating": rating, "destination_id": destinationID, "user_id":userID, "review_title":review_title, "destination_name":destination_name, "create_date":timeStamp])
        return docRef.documentID
    }
    
    static func updateReviewById(reviewId: String, rating:Int, comment:String, review_title:String) async throws{
        let docRef = reviewCollection.document(reviewId)
        
        try await docRef.updateData(["rating":rating, "comment":comment, "review_title":review_title])
    }
        
    //MARK: get all the reivews inside the destination
    static func getReviewsIdsByDestinationId(destination_id:String) async throws -> [Review]{
        let snapshot = try await reviewCollection.whereField("destination_id", isEqualTo: destination_id).getDocuments()

        return snapshot.documents.compactMap { document in
            try? document.data(as: Review.self)
        }
    }
    
    static func getReviewsByIds(reviewIds: [String]) async throws -> [Review]? {
        var reviews: [Review] = []
        for reviewId in reviewIds {
            if let review = try await getReviewById(reviewId: reviewId) {
                reviews.append(review)
            } else {
                print("Error getting review by id \(reviewId)")
            }
        }
        return reviews
    }
    
    static func removeReviewFromDestination(byId reviewIds: String) async throws {
        let reviewDocument = try await reviewCollection.document(reviewIds).getDocument()
        let reviewdata = reviewDocument.data()
        let destinationId = reviewdata?["destination_id"] as? String ?? ""
        print("destinationId", destinationId)
        try await destinationCollection.document(destinationId).updateData([
            "reviews" : FieldValue.arrayRemove([reviewIds])
        ])
    }
    
    static func removeReviewFromProfile(byId reviewIds: String) async throws{
        let reviewDocument = try await reviewCollection.document(reviewIds).getDocument()
        let reviewdata = reviewDocument.data()
        let userId = reviewdata?["user_id"] as? String ?? ""
        print("userId", userId)
        try await profileCollection.document(userId).updateData([
            "review_list" : FieldValue.arrayRemove([reviewIds])
        ])
    }
    
    static func removeReviewFromReviews(byId reviewIds: String) {
        reviewCollection.document(reviewIds).delete()
    }
    
    static func getReviewByDestinationNameAndUserId(destinationName: String, userId: String) async throws -> Review? {
        let destinationQuery = destinationCollection.whereField("name", isEqualTo: destinationName)
        let destinationQuerySnapshot = try await destinationQuery.getDocuments()

        guard let destinationDocument = destinationQuerySnapshot.documents.first else {
            return nil
        }

        let destinationId = destinationDocument.documentID

        let reviewQuery = reviewCollection
            .whereField("destination_id", isEqualTo: destinationId)
            .whereField("user_id", isEqualTo: userId)

        let reviewSnapshot = try await reviewQuery.getDocuments()

        guard let reviewDocument = reviewSnapshot.documents.first else {
            return nil
        }

        return try? reviewDocument.data(as: Review.self)
    }

}
