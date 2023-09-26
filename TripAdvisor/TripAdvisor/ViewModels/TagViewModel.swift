//
//  TagViewModel.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/12/23.
//

import SwiftUI
import Foundation

@MainActor
class TagViewModel: ObservableObject {
    @Published var selectedTags: [String] = []
    
    var originalTagOrder: [String: Int] = [:]
    var homeViewModel: HomeViewModel
    
    let allTag = "All"
    let fixedTags: [String] = ["Culture", "Historic", "Scenic", "Nature"]
    
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    var tags: [String] {
        fixedTags
    }
    
    
    func isSelected(tag: String) -> Bool {
        selectedTags.contains(tag)
    }
    
    func toggleTag(_ tag: String) {
        if isSelected(tag: tag) {
            selectedTags.removeAll { $0 == tag }
        } else {
            selectedTags.append(tag)
        }
        homeViewModel.selectedTags = selectedTags
        selectedTags.sort { originalTagOrder[$0, default: 0] < originalTagOrder[$1, default: 0] }
        
        homeViewModel.filterAndSortDestinations(&homeViewModel.filteredDestinations)
    }
    
    func applyMultipleTagsFilter(destinations: inout [Destination]) {
        if selectedTags.isEmpty {
            return
        }
        
        destinations = destinations.filter { destination in
            selectedTags.allSatisfy { tag in
                destination.tags.contains(tag)
            }
        }
    }
    
}




