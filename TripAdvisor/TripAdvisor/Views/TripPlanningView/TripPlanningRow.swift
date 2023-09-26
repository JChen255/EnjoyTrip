//
//  TripPlanningRow.swift
//  TripAdvisor
//
//  Created by Janine Chen on 8/14/23.
//

import SwiftUI

struct TripPlanningRow: View {
    var trip: Trip
    var destination: Destination
    @EnvironmentObject var tripPlanViewModel: TripPlanViewModel
    @Binding var selectedTrips: [Trip]
    
    var body: some View {
        HStack{
            if trip.destinations.count != 0{
                Image(trip.destinations[0].destionation_image[0])
                    .resizable()
                    .frame(width: 70, height: 70)
                    .cornerRadius(10)
            }else{
                Image("default")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading){
                Text(trip.name)
                    .font(.title3)
                    .bold()
                Text("\(trip.destinations.count) saves")
            }
            Spacer()
            Button{
                tripPlanViewModel.toggleDestinationInTrip(destination, trip, tripPlanViewModel)
                if !tripPlanViewModel.tripContainsDestination(destination, trip){
                    selectedTrips.append(trip)
                    print("111", selectedTrips)
                }else{
                    if let idx = selectedTrips.firstIndex(where: { $0.id == trip.id }){
                        selectedTrips.remove(at: idx)
                    }
                    print("222", selectedTrips)
                }
            }label: {
                Image(systemName: tripPlanViewModel.tripContainsDestination(destination, trip) ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }
}

//struct TripPlanningRow_Previews: PreviewProvider {
//    static var trips = TripPlanViewModel().trips
//    static var destinations = HomeViewModel().destinations
//    static var previews: some View {
//        TripPlanningRow(trip: trips[0], destination: trips[0].destinations[0])
//            .environmentObject(TripPlanViewModel())
//    }
//}
