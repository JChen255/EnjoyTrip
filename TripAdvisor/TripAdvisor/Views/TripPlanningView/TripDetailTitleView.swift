//
//  TripDetailView.swift
//  TripAdvisor
//
//  Created by Janine Chen on 8/12/23.
//

import SwiftUI

struct TripDetailTitleView: View {
    @State var trip: Trip
    @EnvironmentObject var tripPlanViewModel: TripPlanViewModel
    @EnvironmentObject private var settingViewModel: SettingViewModel
    @State private var isEdited = false
    @State private var selectedCurrency: Currency = .usd
    
    
    var formattedTotalCost: String {
        if let storedUserId = UserDefaults.standard.string(forKey: "UserId"),
           let selectedCurrency = UserDefaults.standard.string(forKey: storedUserId),
           let currencyInfo = currencyInfo[Currency(rawValue: selectedCurrency) ?? .usd] {
            
            let totalCostInSelectedCurrency = trip.totalCost * currencyInfo.conversionRate
            return "\(currencyInfo.symbol) \(String(format: "%.2f", totalCostInSelectedCurrency)) \(selectedCurrency)"
            
        } else {
            return "$ \(String(format: "%.2f", trip.totalCost)) USD"
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(trip.name)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button {
                    isEdited.toggle()
                } label: {
                    Image(systemName: "pencil.circle")
                        .foregroundColor(.gray)
                }
            }
            .padding(.all)
            
            HStack {
                Label(String(trip.members), systemImage: "person")
                Label(formattedTotalCost, systemImage: "creditcard")
                Text(trip.isPrivate ? "Private Trip" : "Public Trip")
                Spacer()
            }
            .padding(.all)
            .onReceive(settingViewModel.$selectedCurrency) { newCurrency in
                selectedCurrency = newCurrency
            }

        }
        .sheet(isPresented: $isEdited) {
            EditTripSheetView(isEdited: $isEdited, alertMessage: "", isDeleteAlert: false, isEditAlert: false, trip: $trip)
        }
    }
}


struct TripDetailView_Previews: PreviewProvider {
    static var trips = TripPlanViewModel().trips
    static var previews: some View {
        TripDetailTitleView(trip: trips[0])
            .environmentObject(TripPlanViewModel())
    }
}
