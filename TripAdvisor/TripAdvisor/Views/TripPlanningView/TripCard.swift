//
//  TripCard.swift
//  TripAdvisor
//
//  Created by Janine Chen on 8/12/23.
//

import SwiftUI

struct TripCard: View {
    var trip: Trip
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color.white)
                .frame(width: 400, height: 210)
            if trip.destinations.count != 0{
                Image(trip.destinations[0].destionation_image[0])
                    .resizable()
                    .frame(width: 370, height: 200)
                    .cornerRadius(20)
            }else{
                Image("default")
                    .resizable()
                    .frame(width: 370, height: 200)
                    .cornerRadius(20)
            }
            
            Text(trip.name)
                .frame(width: 300, alignment: .leading)
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .offset(x: -10 , y: 60)
        }
    }
}

struct TripCard_Previews: PreviewProvider {
    static var trips = TripPlanViewModel().trips
    static var previews: some View {
        TripCard(trip: trips[0])
    }
}
