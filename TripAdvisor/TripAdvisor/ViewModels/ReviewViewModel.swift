//
//  ReviewViewModel.swift
//  TripAdvisor
//
//  Created by wade hu on 8/15/23.
//

import Foundation

class ReviewViewModel: ObservableObject {
    @Published var destinationReviews:[Review]?
    @Published var theUserReviewInDestination: Review?
    
    func updateReview(reviewId: String, rating:Int, comment:String, review_title:String) async throws {
        do{
            try await ReviewService.updateReviewById(reviewId: reviewId, rating: rating, comment: comment, review_title: review_title)
        } catch {
            print("Error fetching user data: \(error)")
        }
    }
    
    func createReview(comment: String, rating: Int, userID: String, review_title: String, destination_name: String) async throws {
        let reviewID:String = ReviewService.generatedId()
        var author:String = ""
        var destinationID = ""
        
        do {
            print("The destionName I am using is \(destination_name)")
            destinationID = try await DestinationService.getDestinationIDbyName(destinationName: destination_name) ?? "didn't get it!!!"
            print("I got this destinationID \(destinationID) ------------------")
        } catch {
            print("Error getting profileID from the profile using name: \(error)")
        }
        
        do {
            author = try await ProfileService.getProfileById(profileId: UserDefaults.standard.string(forKey: "UserId") ?? "")?.name ?? ""
        } catch {
            print("Error getting username from the profile: \(error)")
        }
        
        do {
            try await ReviewService.createReview(author: author, comment: comment, id: reviewID, rating: rating, destinationID: destinationID, userID: userID, review_title: review_title, destination_name: destination_name)
        } catch {
            print("Error adding review to the reviews collection: \(error)")
        }
        
        do {
            try await DestinationService.addReviewToDestinationById(destinationId: destinationID, reviewId: reviewID)
        } catch {
            print("Error adding review to the destination list: \(error)")
        }
        
        do {
            try await ProfileService.addReviewToProfileById(profileId: userID, reviewId: reviewID)
        } catch {
            print("Error adding review to the profile list: \(error)")
        }
        
    }

    func fetchDestinationReviewData(destination_id:String) async {
        do{
            self.destinationReviews = try await ReviewService.getReviewsIdsByDestinationId(destination_id: destination_id)
        } catch {
            print("Error fetching user data: \(error)")
        }
    }
    
    func getDesitnationReviewList() -> [Review]{
        return self.destinationReviews ?? []
    }
    
    func deleteReview(_ reviewId: String){
        ReviewService.removeReviewFromReviews(byId: reviewId)
    }
    
    
    func setCurrentReviewInDestination(destinationName:String, userId:String) async{
        do{
            self.theUserReviewInDestination = try await ReviewService.getReviewByDestinationNameAndUserId(destinationName: destinationName, userId: userId)
        }   catch {
            print("Error fetching user data: \(error)")
        }
    }
    
}
