//
//  Review.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/12/23.
//

import Foundation
import SwiftUI

struct Review: Hashable, Codable, Identifiable {
    let id: String
    let author: String
    let rating: Double
    let comment: String
    let user_id: String
    let destination_id: String
    let destination_name: String
    let review_title: String
    let create_date: Date
}
