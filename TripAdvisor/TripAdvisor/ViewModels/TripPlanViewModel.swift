//
//  TripPlanViewModel.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI

@MainActor
class TripPlanViewModel: ObservableObject {
    @Published var tripName = ""
    @Published var numOfMember = ""
    @Published var isPublic = false
    @Published var trips: [Trip] = []
    @Published var destinations: [Destination] = []

    func loadTrips(userId: String) async {
        do {
            self.trips = try await TripService.getAllTrips(forUserID: userId)
        } catch {
            print("Error fetching trips: \(error)")
        }
    }
    
    enum TripValidationError: Error{
        case emptyTripName
        case invalidNumberOfMembers
    }
    
    func addNewTrip(_ name: String, _ members: String, _ isPrivate: Bool, _ destinations: [Destination], _ tripPlanningViewModel: TripPlanViewModel, _ isPresent: inout Bool, _ alertMessage: inout String, _ isAlert: inout Bool) -> Bool{
        do {
            guard !name.isEmpty else {
                throw TripValidationError.emptyTripName
            }
            
            guard let numberOfMembers = Int(members) else {
                throw TripValidationError.invalidNumberOfMembers
            }
            
            let userId = TripService.generateId()
            let newTrip = Trip(id: userId, name: name, members: numberOfMembers, isPrivate: isPrivate, destinations: destinations)
            tripPlanningViewModel.trips.append(newTrip)
            isPresent.toggle()
            return true
        } catch let error as TripValidationError {
            switch error {
                case .emptyTripName:
                    alertMessage = "Trip name cannot be empty."
                case .invalidNumberOfMembers:
                    alertMessage = "Number of members should be an integer."
            }
            isAlert = true
        } catch{
            print("An unexpected error occurred")
        }
        return false
    }
    
    func addNewTriptoFirebase(_ name: String, _ members: String, _ isPrivate: Bool, _ userId: String, _ destinations: [Destination]) async throws {
        let id = TripService.generateId()
        try! await TripService.addTrip(id: id, name: name, members: Int(members)!, isPrivate: isPrivate, user_id: userId, destinations: [])
    }
    
    func updateTrip(_ editedTrip: Trip, _ trip: inout Trip, _ tripPlanningViewModel: TripPlanViewModel, _ name: String, _ members: String, _ alertMessage: inout String, _ isEditAlert: inout Bool) -> Bool{
        do {
            guard !name.isEmpty else {
                throw TripValidationError.emptyTripName
            }
            guard Int(members) != nil else{
                throw TripValidationError.invalidNumberOfMembers
            }
            if let index = tripPlanningViewModel.trips.firstIndex(where: { $0.id == editedTrip.id }) {
                tripPlanningViewModel.trips[index] = editedTrip
            } else {
                print("Invalid Index")
            }
            trip = editedTrip
            alertMessage = ""
            isEditAlert = false
            return true
        } catch let error as TripValidationError {
            switch error {
                case .emptyTripName:
                    alertMessage = "Trip name cannot be empty."
                case .invalidNumberOfMembers:
                    alertMessage = "Number of members should be an integer."
            }
            isEditAlert = true
        } catch {
            print("An unexpected error occurred: \(error)")
            isEditAlert = true
        }
        return false
    }
    
    func updateTripinFirebase(_ trip: Trip) async {
        try! await TripService.updateTrip(trip: trip)
    }
    
    func deleteTrip(_ trip: Trip, _ tripPlanViewModel: TripPlanViewModel){
        if let index = tripPlanViewModel.trips.firstIndex(where: { $0.id == trip.id}){
            tripPlanViewModel.trips.remove(at: index)
        }
        TripService.deleteTrip(byId: trip.id!)
    }
    
    func anyTripContainsDestination(_ destination: Destination, _ tripPlanViewModel: TripPlanViewModel) -> Bool{
        for trip in tripPlanViewModel.trips{
            if trip.destinations.contains(where: {$0.name == destination.name}){
                return true
            }
        }
        return false
    }
    
    func tripContainsDestination(_ destination: Destination, _ trip: Trip) -> Bool{
        if trip.destinations.contains(where: {$0.name == destination.name}){
            return true
        }
        return false
    }
    
    func tripContainsDestinationinFirebase(_ destination: Destination, _ trip: Trip) async throws-> Bool{
        return try await TripService.tripContainsDestination(destination, trip)
    }
    
    func toggleDestinationInTrip(_ destination: Destination, _ trip: Trip, _ tripPlanViewModel: TripPlanViewModel){
            if tripContainsDestination(destination, trip) {
                guard let tripIndex = tripPlanViewModel.trips.firstIndex(where: { $0.name == trip.name }) else {
                    print("Trip not found.")
                    return
                }
                guard let destinationIndex = tripPlanViewModel.trips[tripIndex].destinations.firstIndex(where: { $0.name == destination.name }) else {
                    print("Destination not found.")
                    return
                }
                tripPlanViewModel.trips[tripIndex].destinations.remove(at: destinationIndex)
            } else {
                guard let tripIndex = tripPlanViewModel.trips.firstIndex(where: { $0.name == trip.name }) else {
                    print("Trip not found.")
                    return
                }
                tripPlanViewModel.trips[tripIndex].destinations.append(destination)
            }
        tripPlanViewModel.objectWillChange.send()
    }
    
    func addDestinationtoTripinFirebase(_ destination: Destination, _ trip: Trip) async throws{
        try await TripService.addDestinationToTrip(destination, trip)
    }
    
    func removeDestinationFromTripInFirebase(_ destination: Destination, _ trip: Trip) async throws {
        try await TripService.removeDestinationFromTrip(destination, trip)
    }
    
    
}
