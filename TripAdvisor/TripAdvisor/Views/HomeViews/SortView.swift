//
//  SortView.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/13/23.
//
import SwiftUI

struct SortView: View {
    @ObservedObject var viewModel: SortViewModel
    @Binding var sortOption: SortViewModel.SortOrder  
    
    var body: some View {
        HStack {
            Spacer()
            
            Picker("Sort Option", selection: $sortOption) { 
                Text("Name: a-z").tag(SortViewModel.SortOrder.alphabetical)
                Text("Name: z-a").tag(SortViewModel.SortOrder.alphabeticalReversed)
                Text("Favorites: low to high").tag(SortViewModel.SortOrder.favoritesCount)
                Text("Favorites: high to low").tag(SortViewModel.SortOrder.favoritesCountReversed)
                Text("Rating: low to high").tag(SortViewModel.SortOrder.rating)
                Text("Rating: high to low").tag(SortViewModel.SortOrder.ratingReversed)
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}


