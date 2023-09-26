//
//  EventService.swift
//  TripAdvisor
//
//  Created by Weiqi Zhuang on 8/16/23.
//

import Foundation
import FirebaseFirestore

final class EventService {
    
    static let shared = EventService()
    private init() { }
    
    static func getAllEvents() async throws -> [Event] {
        let snapshot = try await eventCollection.getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: Event.self)
        }
    }
    
    static func getEventById(eventId: String) async throws -> Event? {
        let document = try await eventCollection.document(eventId).getDocument()
//        return try? document.data(as: Event.self, decoder: firebaseDecoder)
        let data = document.data()
        return Event(id: document.documentID, name: data?["name"] as? String ?? "", image: data?["image"] as? String ?? "")
    }
    
    static func getEventsByIds(eventIds: [String]) async throws -> [Event]? {
        var events: [Event] = []
        for eventId in eventIds {
            if let event = try await getEventById(eventId: eventId){
                events.append(event)
            } else {
                print("Error getting event by id \(eventId)")
            }
        }
        return events
    }
}
