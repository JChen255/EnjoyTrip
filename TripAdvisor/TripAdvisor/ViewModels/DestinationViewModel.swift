//
//  DestinationViewModel.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI
import Foundation

struct StarRatingView: View {
    var rating: Double
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                Image(systemName: getStarImageName(for: index))
                    .foregroundColor(.black.opacity(0.8))
            }
        }
    }
    
    private func getStarImageName(for index: Int) -> String {
        let fractionalPart = rating - Double(index)
        
        if fractionalPart >= 0.75 {
            return "star.fill"
        } else if fractionalPart >= 0.25 {
            return "star.leadinghalf.fill"
        } else {
            return "star"
        }
    }
}

class DestinationDetailViewModel: ObservableObject {
    @Published var destinations: [Destination] = []
    @Published var reviews: [Review] = []
    
    func loadDestinations() async throws {
        //        self.destinations = try await DestinationService.getAllDestinations()
        let destinationDataResults = try await DestinationService.getAllDestinationsData()
        for destinationDataResult in destinationDataResults {
            var newDestination = Destination(data: destinationDataResult)
            newDestination.reviews = try await ReviewService.getReviewsByIds(reviewIds: destinationDataResult.reviews) ?? []
            newDestination.events = try await EventService.getEventsByIds(eventIds: destinationDataResult.events) ?? []
            self.destinations.append(newDestination)
        }
    }
    
    func loadReviews() async throws {
        reviews = try await ReviewService.getAllReivews()!
    }
}
