//
//  ProfileView.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var isAscendingSort:Bool = true
    @State private var theProfile: Profile?
    @State private var isEditingReview = false
    @Binding var showLoginView: Bool
    @Binding var changedReview: Bool
    
    @State private var selectedReviewId: String? = nil
    
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationStack {
            if !profileViewModel.isLoading {
                VStack {
                    Spacer()
                    if let profilePicture = profileViewModel.profilePicture {
                        profilePicture
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .foregroundColor(Color(hue: 0.591, saturation: 0.068, brightness: 0.242))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                            .padding(.top, 20)
                    } else {
                        Image(systemName: "circle.dashed")
                            .font(.system(size: 120))
                            .foregroundColor(Color(hue: 0.591, saturation: 0.068, brightness: 0.242))
                            .padding(.top, 20)
                    }
                    
                    
                    HStack {
                        Text(profileViewModel.userName ?? "Loading Name")
                        NavigationLink(destination: UserProfileEditView(profileViewModel: profileViewModel, showLoginView: $showLoginView)) {
                            Image(systemName: "pencil.circle")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .padding(.bottom, -5)
                        }
                    }
                    .padding()
                    
                    HStack{
                        Text("Reviews history")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Color(.black))
                            .padding(.leading)
                        Spacer()
                        HStack{
                            ReviewSortView(viewModel: profileViewModel.sortViewModel, reviewSortOption: $profileViewModel.sortViewModel.reviewSortOption)
                                .padding(.trailing, 5)
                        }
                        
                    }
                    ScrollView {
                        if !profileViewModel.isLoading {
                            LazyVStack(spacing: 0) {
                                ForEach(profileViewModel.sortedReviews) { review in
                                    NavigationLink {
                                        AddEditReviewView(
                                            destinationName: review.destination_name,
                                            reviewContent: review.comment,
                                            reviewTitle: review.review_title,
                                            reviewRate: Int(review.rating),
                                            reviewId: review.id,
                                            isNewReview: false,
                                            isDeleteAlert: false,
                                            isPresented: $isEditingReview,
                                            changedReview: $changedReview
                                        )
                                    } label: {
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
                                    .animation(.default, value: true)
                                    Divider()
                                }
                            }
                            .frame(width: 400)
                        } else {
                            Text("Loading")
                        }
                    }
                    .padding(.top, 20)
                }
            }
        }.onChange(of: showLoginView) { newValue in
            if !newValue {
                profileViewModel.clearData()
                Task {
                    await profileViewModel.fetchUserData()
                }
            }
        }.onChange(of: changedReview) { newValue in
            if newValue {
                profileViewModel.isLoading = true
                Task {
                    await profileViewModel.fetchUserReviews()
                }
                changedReview = false
            }
        }
//        .task {
//            await profileViewModel.fetchUserReviews()
//        }
        //        .task {
        //            await profileViewModel.fetchUserData()
        //        }
    }
    
    
    func dateToString(_ date:Date) ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
