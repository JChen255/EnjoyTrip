//
//  SingleReviewCardView.swift
//  TripAdvisor
//
//  Created by wade hu on 8/14/23.
//

import SwiftUI

struct SingleReviewCardView: View {
    private var theName:String
    private var theDate:String
    private var theDestination:String
    private var theImagenPath:String
    private var theContent:String
    private var theScore:Int
    private var theReviewTitle:String
    
    init(theName: String, theDate: String, theDestination: String, theImagenPath: String, theContent: String, theScore: Int, theReviewTitle: String) {
        self.theName = theName
        self.theDate = theDate
        self.theDestination = theDestination
        self.theImagenPath = theImagenPath
        self.theContent = theContent
        self.theScore = theScore
        self.theReviewTitle = theReviewTitle
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Spacer()
            
            Text(theReviewTitle)
                .padding(.leading)
                .font(.system(size: 15))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .lineLimit(nil)
            
            HStack{
                VStack(alignment:.leading){
                    Text(theName)
                        .padding(.leading)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .padding(.trailing, 5)
                        .foregroundColor(.black)
                    
                    Text(theDate)
                        .padding(.leading)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    Text("\(theDestination)")
                        .font(.system(size: 15))
                        .padding(.leading)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    HStack{
                        ForEach(0..<theScore, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.black.opacity(0.8))
                        }
                    }
                    .padding(.top, -5)
                    .padding(.leading)
                    
                }
                Spacer()
                
                Image(systemName: theImagenPath)
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                    .padding(.trailing)
            }
            
            Spacer()
            Text(theContent)
                .font(.system(size: 15))
                .foregroundColor(Color(hue: 0.591, saturation: 0.087, brightness: 0.393))
                .padding(.trailing,100)
                .padding(.leading)
                .padding(.horizontal, 5)
            
            Spacer()
        }
        .frame(width: 380, height: 200)
    }
}

struct SingleReviewCardView_Previews: PreviewProvider {
    static var previews: some View {
        SingleReviewCardView(theName: "DefaultNameffffffffffff", theDate: "Default time", theDestination: "default", theImagenPath: "person.circle", theContent: "Some simple text Some simple text Some simple text Some simple text Some simple text", theScore: 3, theReviewTitle: "title titleddddddddddddddddddddd tddddddddddddddddddditle")
    }
}
