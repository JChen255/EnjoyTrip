//
//  Trip.swift
//  TripAdvisor
//
//  Created by Janine Chen on 8/12/23.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct Trip: Identifiable, Codable{
    var id: String?
    var name: String
    var members: Int
    var isPrivate: Bool
    var totalCost: Double {
        destinations.reduce(0) { $0 + ($1.price * Double(members)) }
    }
    var destinations: [Destination]

    static func == (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.id == rhs.id
    }
}
