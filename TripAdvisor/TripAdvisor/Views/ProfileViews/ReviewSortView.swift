//
//  ReviewSortView.swift
//  TripAdvisor
//
//  Created by wade hu on 8/15/23.
//

import SwiftUI

struct ReviewSortView: View {
    @ObservedObject var viewModel: SortViewModel
    @Binding var reviewSortOption: SortViewModel.ReviewSortOrder
    
    var body: some View {
        Picker("Sort Option", selection: $reviewSortOption) {
            Text("Date: Newest First").tag(SortViewModel.ReviewSortOrder.createDate)
            Text("Date: Oldest First").tag(SortViewModel.ReviewSortOrder.createDateReversed)
            Text("Location: A-Z").tag(SortViewModel.ReviewSortOrder.locationAZ)
            Text("Location: Z-A").tag(SortViewModel.ReviewSortOrder.locationZA)
            Text("Rating: Low to High").tag(SortViewModel.ReviewSortOrder.reviewRating)
            Text("Rating: High to Low").tag(SortViewModel.ReviewSortOrder.reviewRatingReversed)
        }
        .pickerStyle(MenuPickerStyle())
    }
}
