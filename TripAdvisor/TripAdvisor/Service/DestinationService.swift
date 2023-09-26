//
//  DestinationService.swift
//  TripAdvisor
//
//  Created by Weiqi Zhuang on 8/15/23.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift
//import FirebaseStorage

struct DestinationDataResultModel: Identifiable, Codable {
    let id: String
    let name: String
    let destionationImage : [String]
    let location: String
    let description: String
    let reviews: [String]
    let price: Double
    let events: [String]
    let tags: [String]
    let favCount: Int
}


final class DestinationService {
    
    static let shared = DestinationService()
    private init() { }
    
    
    static func getAllDestinations() async throws -> [Destination] {
        var result: [Destination] = []
        // MARK: sth to refactor
        let destinationDataResults = try await DestinationService.getAllDestinationsData()
        for destinationDataResult in destinationDataResults {
            var newDestination = Destination(data: destinationDataResult)
            newDestination.reviews = try await ReviewService.getReviewsByIds(reviewIds: destinationDataResult.reviews) ?? []
            newDestination.events = try await EventService.getEventsByIds(eventIds: destinationDataResult.events) ?? []
            result.append(newDestination)
        }
        return result
    }
    
    static func getAllDestinationsData() async throws -> [DestinationDataResultModel] {
        let snapshot = try await destinationCollection.getDocuments()
        return snapshot.documents.compactMap { document in
//            if let result = try? document.data(as: DestinationDataResultModel.self) {
//                return result
//            } else {
//                print("Error auto decoding destination")
//            }
//            return try? document.data(as: DestinationDataResultModel.self)
            let data = document.data()
            return DestinationDataResultModel(id: document.documentID, name: data["name"] as? String ?? "" , destionationImage: data["destination_image"] as? [String] ?? [], location: data["location"] as? String ?? "", description: data["description"] as? String ?? "", reviews: data["reviews"] as? [String] ?? [], price: data["price"] as? Double ?? 1.0, events: data["events"] as? [String] ?? [], tags: data["tags"] as? [String] ?? [] , favCount: data["fav_count"] as? Int ?? 0)
        }
    }
    
    static func getDestinationIDbyName(destinationName: String) async throws -> String? {
        let query = destinationCollection.whereField("name", isEqualTo: destinationName)
        let querySnapshot = try await query.getDocuments()
        
        guard let document = querySnapshot.documents.first else {
            return nil // Destination with the given name not found
        }
        
        return document.documentID
    }

    static func getDestinationById(destinationId: String) async throws -> Destination? {
        guard let destinationDataResult = try await self.getDestinationDataById(destinationId: destinationId) else {
            print("destination dat not found\n")
            return nil
        }
        var newDestination = Destination(data: destinationDataResult)
        newDestination.reviews = try await ReviewService.getReviewsByIds(reviewIds: destinationDataResult.reviews) ?? []
        newDestination.events = try await EventService.getEventsByIds(eventIds: destinationDataResult.events) ?? []
        return newDestination
    }
    
    static func addReviewToDestinationById(destinationId: String, reviewId: String) async throws {
        var destinationData = [String: Any]()
        
        let document = try await destinationCollection.document(destinationId).getDocument()
        
        if var reviews = document.data()?["reviews"] as? [String] {
            reviews.append(reviewId)
            destinationData["reviews"] = reviews
        } else {
            destinationData["reviews"] = [reviewId]
        }
        
        try await destinationCollection.document(destinationId).updateData(destinationData)
    }

    
    static func getDestinationDataById(destinationId: String) async throws -> DestinationDataResultModel? {
        let document = try await destinationCollection.document(destinationId).getDocument()
//        return try? document.data(as: DestinationDataResultModel.self, decoder: firebaseDecoder)
        let data = document.data()
        let result = DestinationDataResultModel(id: document.documentID, name: data?["name"] as? String ?? "" , destionationImage: data?["destination_image"] as? [String] ?? [], location: data?["location"] as? String ?? "", description: data?["description"] as? String ?? "", reviews: data?["reviews"] as? [String] ?? [], price: data?["price"] as? Double ?? 1.0, events: data?["events"] as? [String] ?? [], tags: data?["tags"] as? [String] ?? [] , favCount: data?["fav_count"] as? Int ?? 0)
        return result
    }
    
    static func listenToDestinationData(completion: @escaping ([Destination]) -> Void) {
        destinationCollection.addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents \(error!)")
                completion([])
                return
            }
            var destinations: [Destination] = []
            let group2 = DispatchGroup()
            for document in documents {
                group2.enter()
                let data = document.data()
                var reviews: [Review] = []
                let group = DispatchGroup()
                
                if let reviewRefs = data["reviews"] as? [DocumentReference] {

                    for reviewRef in reviewRefs {
                        group.enter()
                        reviewRef.getDocument { reviewSnapshot, error in
                            if let reviewData = reviewSnapshot?.data() {
                                do {
                                    let jsonData = try JSONSerialization.data(withJSONObject: reviewData, options: [])
                                    let review = try JSONDecoder().decode(Review.self, from: jsonData)
                                    print("\ngot review \(review)")
                                    reviews.append(review)
                                } catch {
                                    print(error)
                                }
                            } else {
                                print("Error fetching review with ID \(reviewRef): \(error!)")
                            }
                            group.leave()
                        }
                    }

                }

                group.notify(queue: DispatchQueue.main){
                    destinations.append(Destination(id: document.documentID, name: data["name"] as? String ?? "" , destionation_image: data["destination_image"] as? [String] ?? [], location: data["location"] as? String ?? "", description: data["description"] as? String ?? "", reviews: reviews, price: data["price"] as? Double ?? 1.0, events: [], tags: data["tags"] as? [String] ?? [] , favCount: data["favCount"] as? Int ?? 0))
                    group2.leave()
                }

            }

            group2.notify(queue: DispatchQueue.main){
                print("\nListened destinations: \(destinations)")
                completion(destinations)
            }

        }
    }
    
    
}
