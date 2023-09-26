//
//  StaticRatingView.swift
//  TripAdvisor
//
//  Created by wade hu on 8/13/23.
//

import SwiftUI

struct StaticRatingView: View {
    
    private var theScore:Double
    private var totalViews:Int
    
    @State private var starOneFilled = false
    @State private var starOneHalfFilled = false
    @State private var starOnePreFilled = false
    
    @State private var starTwoFilled = false
    @State private var starTwoHalfFilled = false
    @State private var starTwoPreFilled = false
    
    @State private var starThreeFilled = false
    @State private var starThreeHalfFilled = false
    @State private var starThreePreFilled = false
    
    @State private var starFourFilled = false
    @State private var starFourHalfFilled = false
    @State private var starFourPreFilled = false
    
    @State private var starFiveFilled = false
    @State private var starFiveHalfFilled = false
    @State private var starFivePreFilled = false
    
    init(theScore: Double, totalViews: Int) {
        self.theScore = theScore
        self.totalViews = totalViews
    }
    
    var body: some View {
        VStack{
                HStack{
                    //star one
                    Image(systemName: starOneFilled ? (starOneHalfFilled ? "star.leadinghalf.filled" : "star.fill") : "star")
                        .font(.system(size: 20))
                        .foregroundColor(starOneFilled || starOnePreFilled ? Color(.black).opacity(0.8) : .gray)
                    //star two
                    Image(systemName: starTwoFilled ? (starTwoHalfFilled ? "star.leadinghalf.filled" : "star.fill") : "star")
                        .font(.system(size: 20))
                        .foregroundColor(starTwoFilled || starTwoPreFilled ? Color(.black).opacity(0.8) : .gray)
                    //star three
                    Image(systemName: starThreeFilled ? (starThreeHalfFilled ? "star.leadinghalf.filled" : "star.fill") : "star")
                        .font(.system(size: 20))
                        .foregroundColor(starThreeFilled || starThreePreFilled ? Color(.black).opacity(0.8) : .gray)
                    //star four
                    Image(systemName: starFourFilled ? (starFourHalfFilled ? "star.leadinghalf.filled" : "star.fill") : "star")
                        .font(.system(size: 20))
                        .foregroundColor(starFourFilled || starFourPreFilled ? Color(.black).opacity(0.8) : .gray)
                    //star five
                    Image(systemName: starFiveFilled ? (starFiveHalfFilled ? "star.leadinghalf.filled" : "star.fill") : "star")
                        .font(.system(size: 20))
                        .foregroundColor(starFiveFilled || starFivePreFilled ? Color(.black).opacity(0.8) : .gray)
                }
                .padding(.bottom,1)
            
            HStack{
                Text(String(format: "%.1f", theScore))
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hue: 0.591, saturation: 0.087, brightness: 0.393))
                
                Text("Star in \(totalViews) reviews")
                    .font(.system(size: 20))
                    .fontWeight(.regular)
                    .foregroundColor(Color(hue: 0.591, saturation: 0.087, brightness: 0.393))
            }
        }.onAppear{
            fillStar(theScore)
        }.frame(height: 100)
    }
    
    func fillStar(_ score:Double){
        switch(score){
        case 0..<0.5 :
            starOnePreFilled = true
        case 0.5..<1 :
            starOneFilled = true
            starOneHalfFilled = true
        case 1 :
            starOneFilled = true
        case (1..<1.5) :
            starOneFilled = true
            starTwoPreFilled = true
        case 1.5..<2 :
            starOneFilled = true
            starTwoFilled = true
            starTwoHalfFilled = true
        case 2 :
            starOneFilled = true
            starTwoFilled = true
        case (2..<2.5) :
            starOneFilled = true
            starTwoFilled = true
            starThreePreFilled = true
        case 2.5..<3 :
            starOneFilled = true
            starTwoFilled = true
            starThreeFilled = true
            starThreeHalfFilled = true
        case 3 :
            starOneFilled = true
            starTwoFilled = true
            starThreeFilled = true
        case (3..<3.5) :
            starOneFilled = true
            starTwoFilled = true
            starThreeFilled = true
            starFourPreFilled = true
        case 3.5..<4 :
            starOneFilled = true
            starTwoFilled = true
            starThreeFilled = true
            starFourFilled = true
            starFourHalfFilled = true
        case 4 :
            starOneFilled = true
            starTwoFilled = true
            starThreeFilled = true
            starFourFilled = true
        case (4..<4.5) :
            starOneFilled = true
            starTwoFilled = true
            starThreeFilled = true
            starFourFilled = true
            starFivePreFilled = true
        case 4.5..<5 :
            starOneFilled = true
            starTwoFilled = true
            starThreeFilled = true
            starFourFilled = true
            starFiveFilled = true
            starFiveHalfFilled = true
        case 5 :
            starOneFilled = true
            starTwoFilled = true
            starThreeFilled = true
            starFourFilled = true
            starFiveFilled = true
            
        default:
            print("error")
        }
    }
}

struct StaticRatingView_Previews: PreviewProvider {
    static var previews: some View {
        StaticRatingView(theScore: 2.7, totalViews: 99)
    }
}
