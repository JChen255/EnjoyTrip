//
//  TripPlanningView.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI

struct TripPlanningView: View {
    @State private var showingSheet = false
    @EnvironmentObject var tripPlanViewModel: TripPlanViewModel
    let defaults = UserDefaults.standard
    @Binding var changedReview: Bool
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Text("Trips")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button{
                        showingSheet.toggle()
                    }label: {
                        Image(systemName: "plus")
                        Text("Add a Trip")
                    }
                    .bold()
                    .font(.headline)
                    .foregroundColor(.gray)
                    .sheet(isPresented: $showingSheet){
                        AddTripSheetView(isPresented: $showingSheet, alertMessage: "", isAlert: false)
                    }
                }
                .padding(.all)
                ScrollView{
                    LazyVStack{
                        ForEach(tripPlanViewModel.trips){ trip in
                            NavigationLink(destination: TripView(trip: trip, changedReview: $changedReview)){
                                TripCard(trip: trip)
                            }
                        }
                    }
                }
                .frame(height: 620)
            }
        }
        .task{
            let authUserId = defaults.object(forKey: "UserId") as? String ?? ""
            await tripPlanViewModel.loadTrips(userId: authUserId)
        }
    }
}

//struct TripPlanningView_Previews: PreviewProvider {
//    @Binding var changedReview: Bool
//    static var previews: some View {
//        TripPlanningView(changedReview: $changedReview)
//            .environmentObject(TripPlanViewModel())
//    }
//}

