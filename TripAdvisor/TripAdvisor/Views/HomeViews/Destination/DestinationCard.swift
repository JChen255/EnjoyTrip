//
//  DestinationCard.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/12/23.
//

import SwiftUI

struct DestinationCard: View {
    var destination: Destination
    @Binding var showingSaveSheet: Bool
    @EnvironmentObject var tripPlanViewModel: TripPlanViewModel
    @Binding var selectedDestination: Destination?
    var isDirectDelete: Bool
    var trip: Trip
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(destination.name)
                .font(.title3)
                .bold()
                .padding(.top,10)
            Text(destination.location)
                .font(.subheadline)
            
            if let firstImage = destination.destionation_image.first {
                Image(firstImage)
                    .resizable()
                    .frame(width: 345, height: 200)
                    .scaledToFill()
                    .cornerRadius(9)
            }
            
            HStack {
                StarRatingView(rating: destination.reviews.averageRating())
                    .font(.subheadline)
                Spacer()
               
                FavButton(showingSaveSheet: $showingSaveSheet, destination: destination, selectedDestination: $selectedDestination, isDirectDelete: isDirectDelete, trip: trip)
            }
            .padding(.top,1)
        
            
            HStack(spacing: 12) {
                ForEach(destination.tags, id: \.self) { tag in
                    TagButton(tag: tag, isSelected: false) {
                    }
                }
            }
            .padding(.top,5)
            Spacer()
        }
        .padding()
        .frame(width: 345, height: 200)
    }
}

//struct DestinationCard_Previews: PreviewProvider {
//    static var destinations = DestinationDetailViewModel().destinations
//    static var previews: some View {
//        DestinationCard(destination: destinations[0], showingSaveSheet: .constant(false), selectedDestination: .constant(destinations[0]))
//            .environmentObject(TripPlanViewModel())
//    }
//}
