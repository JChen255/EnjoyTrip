//
//  TripService.swift
//  TripAdvisor
//
//  Created by Janine Chen on 8/15/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class TripService{
    static let shared = TripService()
    private init(){}

    enum TripServiceError: Error {
        case firestoreError(Error)
        case invalidData
    }
    
    static func generateId() -> String{
        return tripCollection.document().documentID
    }
    
    static func getAllTrips(forUserID userID: String) async throws -> [Trip] {
        let snapshot = try await tripCollection.whereField("user_id", isEqualTo: userID).getDocuments()
        let documents = snapshot.documents
        
        var trips: [Trip] = []
        
        for document in documents {
            let data = document.data()
            let destinations = (data["destination_list"] as? [String]) ?? []
            let tripDestinations = try await fetchDestinations(forIDs: destinations)
            let trip = Trip(
                id: document.documentID,
                name: data["name"] as! String,
                members: data["members"] as! Int,
                isPrivate: data["is_private"] as! Bool,
                destinations: tripDestinations
            )
            trips.append(trip)
        }
        return trips
    }
    
    static func fetchDestinations(forIDs destinationIDs: [String]) async throws -> [Destination] {
        var destinations: [Destination] = []
        
        for destinationID in destinationIDs {
            if let destination = try await DestinationService.getDestinationById(destinationId: destinationID) {
                destinations.append(destination)
            }
        }
        return destinations
    }
    
    static func addTrip(id: String, name: String, members: Int, isPrivate: Bool, user_id: String, destinations: [String]) async throws -> String {
        let docRef = tripCollection.document(id)
        try await docRef.setData(["name": name, "members": members, "is_private": isPrivate, "user_id": user_id, "destinationList": destinations])
        return docRef.documentID
    }
    
    static func updateTrip(trip: Trip) async throws {
        let editTrip = tripCollection.document(trip.id!)
        try await editTrip.updateData(["name": trip.name, "members": trip.members, "is_private": trip.isPrivate])
    }

    static func deleteTrip(byId id: String) {
        tripCollection.document(id).delete()
    }
    
    static func removeDestinationFromTrip(_ destination: Destination, _ trip: Trip) async throws{
        try await tripCollection.document(trip.id!).updateData([
            "destination_list" : FieldValue.arrayRemove([destination.id])
        ])
    }
    
    static func addDestinationToTrip(_ destination: Destination, _ trip: Trip) async throws{
        try await tripCollection.document(trip.id!).updateData([
            "destination_list" : FieldValue.arrayUnion([destination.id])
        ])
    }
    
    static func tripContainsDestination(_ destination: Destination, _ trip: Trip) async throws -> Bool{
        let tripDocument = try await tripCollection.document(trip.id!).getDocument()
        let tripdata = tripDocument.data()
        let destinationList = tripdata?["destination_list"] as? [String] ?? []
        
        return destinationList.contains(where: {$0 == destination.id})
    }
}
