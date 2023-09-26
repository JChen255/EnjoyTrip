//
//  ReviewsSummaryView.swift
//  TripAdvisor
//
//  Created by wade hu on 8/14/23.
//

import SwiftUI

struct ReviewsSummaryView: View {
    @State private var destinationReviews: [Review] = []
    @State  var destinationID: String
    @State private var isAddEditReviewViewPresented = false
    @State private var theScore: Double?
    @State private var currentUserHasReviewed = false
    @State private var destinationName = ""
    @State private var currentUserReview:Review?
    @Binding var changedReview: Bool
  
    var reviewModel = ReviewViewModel()
    
    var excellentCount: Int {
        destinationReviews.filter { review in
            review.rating == 5
        }.count
    }
    
    var goodCount: Int {
        destinationReviews.filter { review in
            review.rating == 4
        }.count
    }
    
    var averageCount: Int {
        destinationReviews.filter { review in
            review.rating == 3
        }.count
    }
    
    var poorCount: Int {
        destinationReviews.filter { review in
            review.rating == 2
        }.count
    }
    
    var terribleCount: Int {
        destinationReviews.filter { review in
            review.rating == 1
        }.count
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Reviews")
                    .font(.system(size: 20))
                    .fontWeight(.regular)
                    .padding(.leading)
                Spacer()
                
                NavigationLink(
                    destination: AddEditReviewView(
                        destinationName: destinationName,
                        reviewContent: currentUserReview?.comment ?? "",
                        reviewTitle: currentUserReview?.review_title ?? "",
                        reviewRate: Int(currentUserReview?.rating ?? 0.0),
                        reviewId: currentUserReview?.id ?? ReviewService.generatedId(),
                        isNewReview: !currentUserHasReviewed,
                        isDeleteAlert: false,
                        isPresented: $isAddEditReviewViewPresented,
                        changedReview: $changedReview
                    )
                ) {
                    Image(systemName: "square.and.pencil.circle")
                        .font(.system(size: 40))
                        .foregroundColor(Color(hue: 0.591, saturation: 0.068, brightness: 0.242))
                }
                .padding(.trailing)
            }
            .frame(height: 10)
            
            if let score = theScore {
                StaticRatingView(theScore: score, totalViews: destinationReviews.count)
            }
            
            RatingBlockView(
                excellentCount: excellentCount,
                goodCount: goodCount,
                averageCount: averageCount,
                poorCount: poorCount,
                terribleCount: terribleCount
            )
            .padding(.leading)
            
            ScrollView {
                LazyVStack {
                    ForEach(destinationReviews) { review in
                        SingleReviewCardView(
                            theName: review.author,
                            theDate: dateToString(review.create_date),
                            theDestination: review.destination_name,
                            theImagenPath: "photo.circle",
                            theContent: review.comment,
                            theScore: Int(review.rating),
                            theReviewTitle: review.review_title
                        )
                    }
                }
            }
            .padding(.top, 30)
            .frame(width: 420)
        }
        .task {
            await reviewModel.fetchDestinationReviewData(destination_id: destinationID)
            destinationReviews = reviewModel.getDesitnationReviewList()
            
            await reviewModel.setCurrentReviewInDestination(destinationName: destinationName, userId:  UserDefaults.standard.string(forKey: "UserId") ?? "")
            
            var tempSum = 0.0
            
            for desti in destinationReviews {
                tempSum += desti.rating
            }
            theScore = destinationReviews.isEmpty ? nil : tempSum / Double(destinationReviews.count)
            
            currentUserHasReviewed = destinationReviews.contains { review in
                review.user_id == UserDefaults.standard.string(forKey: "UserId")
            }
            
            do {
                destinationName = try await DestinationService.getDestinationById(destinationId: destinationID)?.name ?? "error:can't find dest name"
            } catch {
                print("error: \(error)")
            }
            
            self.currentUserReview = (reviewModel.theUserReviewInDestination ?? Review(id: ReviewService.generatedId(), author: ProfileViewModel().userName ?? "", rating: 0, comment: "", user_id:UserDefaults.standard.string(forKey: "UserId") ?? "", destination_id: destinationID, destination_name: destinationName, review_title: "", create_date: Date()) )
            
            print("current user is ! \(String(describing: currentUserReview))")
            
        }
    }
    
    func dateToString(_ date:Date) ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
}

//struct ReviewsSummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewsSummaryView(destinationID: "td6Wqy0pyKDk8k3ARFd2")
//    }
//}
