//
//  DestinationDetailView.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI

struct DestinationDetailView: View {
    var destination: Destination
    var trip: Trip
    @State private var showingSaveSheet = false
    @Binding var selectedDestination: Destination?
    var isDirectDelete: Bool
    let defaultTrip = Trip(name: "default", members: 0, isPrivate: false, destinations: [])
    
    @EnvironmentObject private var settingViewModel: SettingViewModel
    @Binding var changedReview: Bool
    @State private var selectedCurrency: Currency = .usd
    
    
    var formattedPrice: String {
        if let storedUserId = UserDefaults.standard.string(forKey: "UserId"),
           let selectedCurrency = UserDefaults.standard.string(forKey: storedUserId),
           let currencyInfo = currencyInfo[Currency(rawValue: selectedCurrency) ?? .usd] {
            
            let priceInSelectedCurrency = destination.price * currencyInfo.conversionRate
            return "\(currencyInfo.symbol) \(String(format: "%.2f", priceInSelectedCurrency)) \(selectedCurrency)"
            
        } else {
            return "$ \(String(format: "%.2f", destination.price)) USD"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment:.leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(destination.destionation_image.indices, id: \.self) { index in
                            Image(destination.destionation_image[index])
                                .resizable()
                                .frame(width: 360, height: 230)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(9)
                        }
                    }
                    .scrollIndicators(.visible)
                }
                
                VStack(alignment: .leading){
                    HStack{
                        Text(destination.name)
                            .bold()
                            .font(.title)
                        Spacer()
                        FavButton(showingSaveSheet: $showingSaveSheet, destination: destination, selectedDestination: $selectedDestination, isDirectDelete: isDirectDelete, trip: trip)
                            .padding(.leading,100)
                            .sheet(isPresented: $showingSaveSheet, onDismiss: {
                            }){
                                SaveDestinationSheetView(destination: destination, selectedTrips: [])
                            }
                        
                    }
                    
                    HStack{
                        StarRatingView(rating: destination.reviews.averageRating())
                            .font(.callout)
                            
                        
                        NavigationLink(destination: ReviewsSummaryView(destinationID: destination.id, changedReview: $changedReview)) {
                            Text("\(destination.reviews.count) Reviews")
                                .font(.callout)
                                .bold()
                                .foregroundColor(.gray)
                                .underline()
                        }
                        .navigationTitle(destination.name)
                    }.padding(.top, 5)

                    Spacer()
                    
                    VStack{
                        HStack{
                            Image(systemName: "mappin.and.ellipse")
                            Text("\(destination.location)")
                                .font(.callout)
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "creditcard")
                            Text(formattedPrice)
                                .font(.callout)
                            Spacer()
                        }
                        
                        .onReceive(settingViewModel.$selectedCurrency) { newCurrency in
                            selectedCurrency = newCurrency
                        }
                    }
                }
                
                Text(destination.description)
                    .font(.body)
                    .foregroundColor(.black.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.vertical,10)
                    .padding(.horizontal, 5)
                
                Text("Things To Do")
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 3)
                
                Spacer()
                
                ScrollView(.horizontal){
                    LazyHStack {
                        ForEach(destination.events, id: \.self) { event in
                            VStack {
                                Image(event.image)
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                Text(event.name)
                                    .font(.subheadline)
                                    .frame(width:150, height: 50)
                            }
                            .padding()
                            .background(.bar)
                            .cornerRadius(8)
                        }
                    }
                }
            
            }
            .padding()
        }
        .navigationBarTitle(destination.name, displayMode: .inline)
    }
}

//struct DestinationDetailView_Previews: PreviewProvider {
//    static var trips = TripPlanViewModel().trips
//    static var previews: some View {
//        let goldenb = ThingsToDo(eventName: "Golden Bridgffffffffff fdmgskdlmgslkdge", eventImage: "goldenbridge")
//        let chinatown = ThingsToDo(eventName: "China Towfffffffffffffffn", eventImage: "chinatown")
//        let timesquare = ThingsToDo(eventName: "Time Square", eventImage: "timesquare")
//
//        let dummyImage1 = "newyork"
//        let dummyImage2 = "sanfran"
//
//        let dummyDestination = Destination(id: "1", name: "Destination 1", destionation_image: [dummyImage1, dummyImage2], location: "City A", description: "Description 1", reviews: [], price: 100.0, events: [goldenb, chinatown, timesquare], tags: ["Nature"], favCount: 300)
//        DestinationDetailView(destination: dummyDestination, selectedDestination: .constant(trips[0].destinations[0]), isDirectDelete: false)
//            .environmentObject(TripPlanViewModel())
//    }
//}
