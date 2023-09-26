//
//  TripView.swift
//  TripAdvisor
//
//  Created by Janine Chen on 8/12/23.
//

import SwiftUI

struct TripView: View {
    var trip: Trip
    @EnvironmentObject var tripPlanViewModel: TripPlanViewModel
    @State private var showingSaveSheet = false
    @State private var selectedDestination: Destination?
    let defaults = UserDefaults.standard
    @Binding var changedReview: Bool
    
    var body: some View {
        VStack{
            TripDetailTitleView(trip: trip)
            ScrollView{
                LazyVStack{
                    ForEach(trip.destinations){destination in
                        NavigationLink(destination:  DestinationDetailView(destination: destination, trip: trip, selectedDestination: $selectedDestination, isDirectDelete: true, changedReview: $changedReview)){
                            DestinationCard(destination: destination, showingSaveSheet: $showingSaveSheet, selectedDestination: $selectedDestination, isDirectDelete: true, trip: trip)
                                .foregroundColor(.black)
                                .padding(.top,55)
                                .padding(.bottom,70)
                        }
                    }
                }
            }
        }
        .task{
            let authUserId = defaults.object(forKey: "UserId") as? String ?? ""
            try? await tripPlanViewModel.loadTrips(userId: authUserId)
        }
    }
}

//struct TripView_Previews: PreviewProvider {
//    static var trips = TripPlanViewModel().trips
//    static var previews: some View {
//        TripView(trip: trips[0])
//            .environmentObject(TripPlanViewModel())
//    }
//}
