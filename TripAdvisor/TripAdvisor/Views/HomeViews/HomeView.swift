//  HomeView.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI

struct HomeView: View {
    @State private var isSearching = false
    
    @ObservedObject var viewModel: HomeViewModel
    @StateObject var tagViewModel: TagViewModel
    @State private var showingSaveSheet = false
    @EnvironmentObject var tripPlanViewModel: TripPlanViewModel
    @State private var selectedDestination: Destination?
    @Binding var changedReview: Bool
    let defaults = UserDefaults.standard
    let defaultTrip = Trip(name: "default", members: 0, isPrivate: false, destinations: [])
    
    init(changedReview: Binding<Bool>? = nil) {
        let viewModel = HomeViewModel()
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _tagViewModel = StateObject(wrappedValue: TagViewModel(homeViewModel: viewModel))
        _changedReview = changedReview ?? Binding.constant(false)
    }
    
    var body: some View {
        NavigationView {
            if !viewModel.destinations.isEmpty{
                VStack(spacing: 0) {
                    SearchBar(searchQuery: $viewModel.searchQuery, isSearching: $isSearching, viewModel: viewModel) {
                    }
                    .frame(width: 360)
                    .padding(.horizontal)
                    
                    TagView(viewModel: tagViewModel)
                        .padding(.top, 15)
                        .padding(.bottom, 5)
                    
                    SortView(viewModel: viewModel.sortViewModel, sortOption: $viewModel.sortViewModel.sortOption)
                        .padding(.horizontal)
                    List(viewModel.filteredAndSortedDestinations) { destination in
                        NavigationLink(destination: DestinationDetailView(destination: destination, trip: defaultTrip, selectedDestination: $selectedDestination, isDirectDelete: false, changedReview: $changedReview)
                        ) {
                            DestinationCard(destination: destination, showingSaveSheet: $showingSaveSheet, selectedDestination: $selectedDestination, isDirectDelete: false, trip: defaultTrip)
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 60)
                        .padding(.horizontal, 5)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                    
                }
                .padding(.leading, 20)
            } else {
                VStack{
                    Image("loading")
                        .resizable()
                        .frame(width: 380, height: 280)
                    Text("Loading...")
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.9))
                }
                
            }
        }
        .sheet(item: $selectedDestination, onDismiss: {
            selectedDestination = nil
        }) { destination in
            SaveDestinationSheetView(destination: destination, selectedTrips: [])
        }
        .task {
            try? await viewModel.loadDestinations()
            await tripPlanViewModel.loadTrips(userId: UserDefaults.standard.object(forKey: "UserId") as? String ?? "")
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(TripPlanViewModel())
    }
}
