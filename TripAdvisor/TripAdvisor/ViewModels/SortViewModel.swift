//
//  SortViewModel.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/13/23.
//

import Foundation

@MainActor
class SortViewModel: ObservableObject {
    @Published var sortOption: SortOrder = .alphabetical
    @Published var reviewSortOption: ReviewSortOrder = .locationAZ
    
    enum SortOrder {
        case alphabetical
        case alphabeticalReversed
        case favoritesCount
        case favoritesCountReversed
        case rating
        case ratingReversed
    }
    
    enum ReviewSortOrder {
        case createDate
        case createDateReversed
        case locationAZ
        case locationZA
        case reviewRating
        case reviewRatingReversed
    }
    
    func sortDestinations(_ destinations: inout [Destination]) {
        switch sortOption {
        case .alphabetical:
            destinations.sort { $0.name < $1.name }
        case .alphabeticalReversed:
            destinations.sort { $0.name > $1.name }
        case .favoritesCount:
            destinations.sort { $0.favCount < $1.favCount }
        case .favoritesCountReversed:
            destinations.sort { $0.favCount > $1.favCount }
        case .rating:
            destinations.sort { $0.reviews.averageRating() < $1.reviews.averageRating() }
        case .ratingReversed:
            destinations.sort { $0.reviews.averageRating() > $1.reviews.averageRating() }
        }
    }
    
    func sortReviews(_ reviews: inout [Review]) {
        switch reviewSortOption {
        case .createDate:
            reviews.sort { $0.create_date > $1.create_date }
        case .createDateReversed:
            reviews.sort { $0.create_date < $1.create_date }
        case .locationAZ:
            reviews.sort { $0.destination_name < $1.destination_name }
        case .locationZA:
            reviews.sort { $0.destination_name > $1.destination_name }
        case .reviewRating:
            reviews.sort { $0.rating < $1.rating }
        case .reviewRatingReversed:
            reviews.sort { $0.rating > $1.rating }
        }
    }
}
