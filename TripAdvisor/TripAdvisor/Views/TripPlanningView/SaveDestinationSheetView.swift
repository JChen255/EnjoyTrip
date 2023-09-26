//
//  SaveDestinationSheetView.swift
//  TripAdvisor
//
//  Created by Janine Chen on 8/14/23.
//

import SwiftUI

struct SaveDestinationSheetView: View {
    var destination : Destination
    @State private var showAddTripSheet = false
    @EnvironmentObject var tripPlanViewModel: TripPlanViewModel
    let defaults = UserDefaults.standard
    @State var selectedTrips: [Trip]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            Text("Select a Trip to save to:")
                .font(.title3)
                .bold()
                .padding(.all)
            ScrollView{
                LazyVStack{
                    ForEach(tripPlanViewModel.trips) { trip in
                        TripPlanningRow(trip: trip, destination: destination, selectedTrips: $selectedTrips)
                    }
                }
            }
            .frame(height: 260)
            
            Divider()
            
            HStack{
                Button{
                    showAddTripSheet.toggle()
                }label: {
                    Image(systemName: "plus.circle")
                    Text("Create a Trip")
                        .bold()
                }
                .foregroundColor(.black)
                
                Spacer()
                
                Button {
                    for trip in tripPlanViewModel.trips {
                        if selectedTrips.contains(where: { $0.id == trip.id }) {
                            Task {
                                do {
                                    let isContain = try await tripPlanViewModel.tripContainsDestinationinFirebase(destination, trip)
                                    if !isContain {
                                        try await tripPlanViewModel.addDestinationtoTripinFirebase(destination, trip)
                                    }
                                } catch {
                                    print("Error: \(error)")
                                }
                            }
                        } else {
                            Task {
                                do {
                                    let isContain = try await tripPlanViewModel.tripContainsDestinationinFirebase(destination, trip)
                                    if isContain {
                                        try await tripPlanViewModel.removeDestinationFromTripInFirebase(destination, trip)
                                    }
                                } catch {
                                    print("Error: \(error)")
                                }
                            }
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                label: {
                    Text("Done")
                        .bold()
                        .frame(width: 90, height: 45)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
            }
            .padding(.all)
        }
        .presentationDetents([.medium])
        .sheet(isPresented: $showAddTripSheet){
            AddTripSheetView(isPresented: $showAddTripSheet, alertMessage: "", isAlert: false)
        }
        .task{
            let authUserId = defaults.object(forKey: "UserId") as? String ?? ""
            await tripPlanViewModel.loadTrips(userId: authUserId)
            selectedTrips = tripPlanViewModel.trips.filter { trip in
                tripPlanViewModel.tripContainsDestination(destination, trip)
            }
            print("000", selectedTrips)
        }
    }
}

//struct SaveDestinationSheetView_Previews: PreviewProvider {
//    static var trips = TripPlanViewModel().trips
//    static var previews: some View {
//        SaveDestinationSheetView(destination: trips[0].destinations[0])
//            .environmentObject(TripPlanViewModel())
//    }
//}
