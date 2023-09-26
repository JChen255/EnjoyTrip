//
//  Destination.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/12/23.
//

import Foundation
import SwiftUI

struct Destination: Identifiable, Codable {
    
    let id: String
    let name: String
    let destionation_image : [String]
    let location: String
    let description: String
    var reviews: [Review]
    let price: Double
    var events: [Event]
    let tags: [String]
    let favCount: Int
    
    init(id: String, name: String, destionation_image: [String], location: String, description: String, reviews: [Review], price: Double, events: [Event], tags: [String], favCount: Int) {
        self.id = id
        self.name = name
        self.destionation_image = destionation_image
        self.location = location
        self.description = description
        self.reviews = reviews
        self.price = price
        self.events = events
        self.tags = tags
        self.favCount = favCount
    }
    
    init(data: DestinationDataResultModel) {
        self.id = data.id
        self.name = data.name
        self.destionation_image = data.destionationImage
        self.location = data.location
        self.description = data.description
        self.reviews = []
        self.price = Double(data.price)
        self.events = []
        self.tags = data.tags
        self.favCount = data.favCount
    }
}
