//
//  HomeViewModel.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var destinations: [Destination] = []
    @Published var reviews: [Review] = []
    @Published var filteredDestinations: [Destination] = []
    @Published var selectedTags: [String] = []
    @Published var searchQuery: String = ""
    @Published var isSearching = false
    //@Published var isLoadingDestinations = false
    
    @Published var sortViewModel = SortViewModel()
    
    var filteredAndSortedDestinations: [Destination] {
        var destinationsToFilterAndSort = destinations
        filterAndSortDestinations(&destinationsToFilterAndSort)
        return destinationsToFilterAndSort
    }
    
    var sortedDestinations: [Destination] {
        var destinationsToSort = filteredDestinations
        sortViewModel.sortDestinations(&destinationsToSort)
        return destinationsToSort
    }
    
    func loadDestinations() async throws {
        self.destinations = try await DestinationService.getAllDestinations()
    }
    init() {
        destinations = []
        filteredDestinations = destinations
        
        filterAndSortDestinations(&filteredDestinations)
    }
    
    func fetchDataFromDatabase() async throws {
        try await loadDestinations()
    }
    
    func filterAndSortDestinations(_ destinations: inout [Destination]) {
        if selectedTags.isEmpty && searchQuery.isEmpty {
            destinations = self.destinations
        } else {
            destinations = self.destinations.filter { destination in
                (selectedTags.isEmpty || selectedTags.allSatisfy { tag in
                    destination.tags.contains(tag)
                }) && (searchQuery.isEmpty ||
                       destination.name.localizedCaseInsensitiveContains(searchQuery) ||
                       destination.location.localizedCaseInsensitiveContains(searchQuery))
            }
        }
        
        sortViewModel.sortDestinations(&destinations)
    }
    
    func applySort() {
        sortViewModel.sortDestinations(&filteredDestinations)
    }
    
    func listenToDestinationsData() {
        DestinationService.listenToDestinationData { data in
            self.destinations = data
            print("\nhere inside listenToDestinationData: \(self.destinations)")
        }
    }
}

extension Array where Element == Review {
    func averageRating() -> Double {
        guard !isEmpty else {
            return 0.0
        }
        let totalRating = reduce(0.0) { $0 + $1.rating }
        return totalRating / Double(count)
    }
}
