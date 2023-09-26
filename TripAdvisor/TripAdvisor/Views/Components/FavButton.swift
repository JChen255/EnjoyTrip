//
//  FavButton.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/12/23.
//

import SwiftUI

struct FavButton: View {
    @Binding var showingSaveSheet: Bool
    @EnvironmentObject var tripPlanViewModel: TripPlanViewModel
    var destination: Destination
    @Binding var selectedDestination: Destination?
    var isDirectDelete: Bool
    var trip: Trip
    @State var isDeleteAlert = false
    
    var body: some View {
        Button(action: {
            if isDirectDelete{
                isDeleteAlert = true
            }
            else{
                showingSaveSheet = true
                selectedDestination = destination
            }
        }) {
            Image(systemName: tripPlanViewModel.anyTripContainsDestination(destination, tripPlanViewModel) ? "heart.fill" : "heart")
                .foregroundColor(.red)
        }
        .alert(isPresented: $isDeleteAlert){
            Alert(
                title: Text("Warning"),
                message: Text("Are you sure you want to delete this destination?"),
                primaryButton: .destructive(
                    Text("Delete"),
                    action: {
                        Task {
                               tripPlanViewModel.toggleDestinationInTrip(destination, trip, tripPlanViewModel)
                               try await tripPlanViewModel.removeDestinationFromTripInFirebase(destination, trip)
                           }
                    }
                ),
                secondaryButton: .default(
                    Text("Dismiss"),
                    action: {
                    }
                )
            )
        }
    }
}

//struct FavButton_Previews: PreviewProvider {
//    static var trips = TripPlanViewModel().trips
//    static var previews: some View {
//        FavButton(showingSaveSheet: .constant(false), destination: trips[0].destinations[0], selectedDestination: .constant(trips[0].destinations[0]), isDirectDelete: false, trip: trips[0])
//            .environmentObject(TripPlanViewModel())
//    }
//}
