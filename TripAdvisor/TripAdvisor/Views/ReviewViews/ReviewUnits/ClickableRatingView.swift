//
//  ClickableRatingStarsView.swift
//  TripAdvisor
//
//  Created by wade hu on 8/12/23.
//

import SwiftUI

struct ClickableRatingView: View {
    @Binding private var theScore:Int
    @State private var starOneFilled = false
    @State private var starTwoFilled = false
    @State private var starThreeFilled = false
    @State private var starFourFilled = false
    @State private var starFiveFilled = false
    
    init(theScore: Binding<Int>) {
        self._theScore = theScore
    }
    
    var body: some View {
              
        VStack{
            Spacer()
            HStack{
                //star one
                Button(action: {
                    theClickedOne(1)
                }) {
                    Image(systemName: starOneFilled ? "star.fill" : "star")
                        .font(.system(size: 25))
                }
                .foregroundColor(starOneFilled ? Color(red: 0.2, green: 0.3, blue: 0.9) : .gray)
                .animation(.default, value: starOneFilled)
                
                //star two
                Button(action: {
                    theClickedOne(2)
                }) {
                    Image(systemName: starTwoFilled ? "star.fill" : "star")
                        .font(.system(size: 25))
                }
                .foregroundColor(starTwoFilled ? Color(red: 0.2, green: 0.3, blue: 0.9) : .gray)
                .animation(.default, value: starTwoFilled)
                
                //star three
                Button(action: {
                    theClickedOne(3)
                }) {
                    Image(systemName: starThreeFilled ? "star.fill" : "star")
                        .font(.system(size: 25))
                }
                .foregroundColor(starThreeFilled ? Color(red: 0.2, green: 0.3, blue: 0.9) : .gray)
                .animation(.default, value: starThreeFilled)
                
                //star four
                Button(action: {
                    theClickedOne(4)
                }) {
                    Image(systemName: starFourFilled ? "star.fill" : "star")
                        .font(.system(size: 25))
                }
                .foregroundColor(starFourFilled ? Color(red: 0.2, green: 0.3, blue: 0.9) : .gray)
                .animation(.default, value: starFourFilled)
                
                //star five
                Button(action: {
                    theClickedOne(5)
                }) {
                    Image(systemName: starFiveFilled ? "star.fill" : "star")
                        .font(.system(size: 25))
                }
                .foregroundColor(starFiveFilled ? Color(red: 0.2, green: 0.3, blue: 0.9) : .gray)
                .animation(.default, value: starFiveFilled)
                
            }.padding()
            
            Text(scoreToDescribe(theScore))
                .font(.system(size: 20))
                .fontWeight(.light)
                .foregroundColor(Color(hue: 0.591, saturation: 0.087, brightness: 0.393))
            Spacer()
        }.frame(height: 120)
        .onAppear {
            theClickedOne(theScore)
        }
        
    }
    
    func scoreToDescribe(_ score:Int) -> String {
        var result:String = ""
        switch score {
        case 0:
            result = "Select a Star"
        case 1:
            result = "Terrible"
        case 2:
            result = "Poor"
        case 3:
            result = "Average"
        case 4:
            result = "Good"
        case 5:
            result = "Excellent"
        default:
            result = "please rate"
        }
        
        return result
    }
    
    func theClickedOne(_ choice:Int) {
        switch choice {
        case 1 :
            if starOneFilled {
                if starTwoFilled || starThreeFilled || starFourFilled || starFiveFilled {
                    // reset action to the stars behind
                    starTwoFilled = false
                    starThreeFilled = false
                    starFourFilled = false
                    starFiveFilled = false
                    // set the socre to star one = 1
                    theScore = 1
                } else {
                    // no others stars filled, so reset self
                    starOneFilled = false
                    theScore = 0
                }
            } else {
                starOneFilled = true
                theScore = 1
            }
        case 2 :
            if starTwoFilled {
                if starThreeFilled || starFourFilled || starFiveFilled {
                    // reset action to the stars behind
                    starThreeFilled = false
                    starFourFilled = false
                    starFiveFilled = false
                    // set the socre to star one = 1
                    theScore = 2
                } else {
                    // no others stars filled, so reset self
                    starOneFilled = false
                    starTwoFilled = false
                    theScore = 0
                }
            } else {
                starOneFilled = true
                starTwoFilled = true
                theScore = 2
            }
        case 3 :
            if starThreeFilled {
                if starFourFilled || starFiveFilled {
                    // reset action to the stars behind
                    starFourFilled = false
                    starFiveFilled = false
                    // set the socre to star one = 1
                    theScore = 3
                } else {
                    // no others stars filled, so reset self
                    starOneFilled = false
                    starTwoFilled = false
                    starThreeFilled = false
                    theScore = 0
                }
            } else {
                starOneFilled = true
                starTwoFilled = true
                starThreeFilled = true
                theScore = 3
            }
        case 4 :
            if starFourFilled {
                if starFiveFilled {
                    // reset action to the stars behind
                    starFiveFilled = false
                    // set the socre to star one = 1
                    theScore = 4
                } else {
                    // no others stars filled, so reset self
                    starOneFilled = false
                    starTwoFilled = false
                    starThreeFilled = false
                    starFourFilled = false
                    theScore = 0
                }
            } else {
                starOneFilled = true
                starTwoFilled = true
                starThreeFilled = true
                starFourFilled = true
                theScore = 4
            }
            
        case 5 :
            if starFiveFilled {
                starOneFilled = false
                starTwoFilled = false
                starThreeFilled = false
                starFourFilled = false
                starFiveFilled = false
                theScore = 0
            } else {
                starOneFilled = true
                starTwoFilled = true
                starThreeFilled = true
                starFourFilled = true
                starFiveFilled = true
                theScore = 5
            }
            
        default:
            print("error input")
        }
    }
}

struct ClickableRatingStarsView_Previews: PreviewProvider {
    @State static private var score = 5 // Initialize the score with the desired value

    static var previews: some View {
        ClickableRatingView(theScore: $score)
    }
}

