//
//  AddEditReviewView.swift
//  TripAdvisor
//
//  Created by wade hu on 8/14/23.
//

import SwiftUI

struct AddEditReviewView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var destinationName:String
    @State var reviewContent:String
    @State var reviewTitle:String
    @State var reviewRate:Int
    @State var reviewId:String
    @State var isNewReview: Bool
    @State var isDeleteAlert:Bool
    @Binding var isPresented: Bool
    @Binding var changedReview: Bool
    
    @State private var showAlert = false
    @State private var successMessage = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var reviewModel = ReviewViewModel()
    
    var body: some View {
        
        VStack{
            
            Spacer()
            VStack{
                Text("Write review for:")
                    .font(.system(size: 25))
                    .fontWeight(.light)
                    .foregroundColor(Color(hue: 0.591, saturation: 0.068, brightness: 0.242))
                
                Text(destinationName)
                    .font(.system(size: 30))
                    .fontWeight(.regular)
                    .padding(.leading)
            }
            .frame(height: 20)
            
            ClickableRatingView(theScore: $reviewRate)
            
            VStack(alignment: .leading){
                Text("Write your view:")
                    .font(.headline)
                    .padding(.leading)
                    .padding(.top)
                
                TextField("what do you want to share about this place?", text: $reviewContent, axis: .vertical)
                    .frame(height: 100)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 4)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .padding([.horizontal], 24)
                
                Text("Title for the review:")
                    .font(.headline)
                    .padding(.leading)
                    .padding(.top)
                
                TextField("write down one single line", text: $reviewTitle)
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 4)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .padding([.horizontal], 24)
                
            }
            Spacer()
            
            HStack{
                Button{
                    // Real time update objects in profileViewModel
                    Task {
                        if isNewReview {
                            do {
                                print("about to CREATE a review using reviewID:\(reviewId)")
                                try await reviewModel.createReview(
                                    comment: reviewContent,
                                    rating: reviewRate,
                                    userID: UserDefaults.standard.string(forKey: "UserId") ?? "",
                                    review_title: reviewTitle,
                                    destination_name: destinationName)
//                                presentationMode.wrappedValue.dismiss()
                            } catch {
                                
                            }
                        } else {
                            do {
                                print("about to UPDATE a review using reviewID:\(reviewId)")
                                try await reviewModel.updateReview(
                                    reviewId: reviewId,
                                    rating: reviewRate,
                                    comment: reviewContent,
                                    review_title: reviewTitle)
//                                presentationMode.wrappedValue.dismiss()
                                isPresented = false
                            } catch {
                                print("Error updating review: \(error)")
                            }
                        }
                        changedReview = true
                        dismiss()
                    }
                }label: {
                    Text("SAVE")
                        .padding(.horizontal, 10)
                        .frame(height: 44)
                        .foregroundColor(.white)
                        .background(Color(red: 0.4, green: 0.5, blue: 1))
                        .cornerRadius(10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Success"),
                        message: Text(successMessage),
                        dismissButton: .default(Text("OK")) {
                            isPresented = false // Dismiss the view
                        }
                    )
                }
                Button{
                    isDeleteAlert = true
                    
                } label: {
                    Text("DELETE")
                        .padding(.horizontal, 10)
                        .frame(height: 44)
                        .foregroundColor(.white)
                        .background(Color(red: 0.4, green: 0.5, blue: 1))
                        .cornerRadius(10)
                }
                .alert(isPresented: $isDeleteAlert){
                    Alert(
                        title: Text("Warning"),
                        message: Text("Are you sure you want to delete this review?"),
                        primaryButton: .destructive(
                            Text("Delete"),
                            action: {
                                Task{
                                    try await ReviewService.removeReviewFromDestination(byId: reviewId)
                                    try await ReviewService.removeReviewFromProfile(byId: reviewId)
                                    ReviewService.removeReviewFromReviews(byId: reviewId)
                                    changedReview = true
                                    dismiss()
                                }
                                
                                
                            }
                        ),
                        secondaryButton: .default(
                            Text("Dismiss"),
                            action: {
                            }
                        )
                    )
                }
            }
            Spacer()
        }
        
    }
}

//struct AddEditReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddEditReviewView(destinationName: "temp temp", reviewContent: "hahahah", reviewTitle: "temp title", reviewRate: 1, reviewId: "default", isPresented:)
//    }
//}
