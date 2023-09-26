//
//  TouchableSingleReviewView.swift
//  TripAdvisor
//
//  Created by wade hu on 8/16/23.
//

import SwiftUI

struct TouchableSingleReviewView: View {
    private var theName:String
    private var theDate:String
    private var theDestination:String
    private var theImagenPath:String
    private var theContent:String
    private var theScore:Int
    
    init(theName: String, theDate: String, theDestination: String, theImagenPath: String, theContent: String, theScore: Int) {
        self.theName = theName
        self.theDate = theDate
        self.theDestination = theDestination
        self.theImagenPath = theImagenPath
        self.theContent = theContent
        self.theScore = theScore
    }
    
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            HStack{
                VStack(alignment:.leading){
                    Text(theName)
                        .padding(.leading, 5)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                    
                    Text(theDate)
                        .padding(.leading, 5)
                    Text("Destination: \(theDestination)")
                        .padding(.leading, 5)
                    
                    HStack{
                        ForEach(0..<theScore, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(hue: 1.0, saturation: 0.006, brightness: 0.235, opacity: 1.0))
                        }
                    }.padding(.leading, 5)
                    
                }
                Spacer()
                
                Image(systemName: theImagenPath)
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                    .padding(.trailing)
            }
            
            Spacer()
            Text(theContent)
                .font(.system(size: 20))
                .fontWeight(.light)
                .foregroundColor(Color(hue: 0.591, saturation: 0.087, brightness: 0.393))
                .multilineTextAlignment(.leading)
                .lineLimit(5)
            
            Spacer()
        }
        .frame(width: 380, height: 200)
        .onTapGesture {
            print("tapped")
            //redirect to AddEditReviewView
            
            
        }
    }
}

struct TouchableSingleReviewView_Previews: PreviewProvider {
    static var previews: some View {
        TouchableSingleReviewView(theName: "DefaultName", theDate: "Default time", theDestination: "default", theImagenPath: "person.circle", theContent: "Some simple text, simple text, sample text, sample text!", theScore: 3)
    }
}
