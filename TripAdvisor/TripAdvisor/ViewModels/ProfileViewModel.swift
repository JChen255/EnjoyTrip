//
//  ProfileViewModel.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var theUser: DBUser?
    @Published var myProfile: Profile?
    @Published var reviewsList: [Review] = []
    @Published var userName: String?
    @Published var profilePicture: Image?
    
    @Published var sortViewModel = SortViewModel()
    @Published var isLoading = true

    init() {
        Task {
            await self.fetchUserData()
        }
    }
    enum SortOrder {
        case alphabetical
        case alphabeticalReversed
    }

    var sortedReviews: [Review] {
        var reviewsToSort = reviewsList
        sortViewModel.sortReviews(&reviewsToSort)
        return reviewsToSort
    }
    
    func clearData() {
        reviewsList = []
        isLoading = true
    }
    
    // Fetch user data asynchronously
    func fetchUserData() async {
        do {
            self.theUser = try await UserService.shared.getUser(userId: UserDefaults.standard.string(forKey: "UserId") ?? "error")
        } catch {
            print("Error fetching user data: \(error)")
        }
        
        do {
            self.reviewsList = try await ReviewService.getReviewsByUserId(userId: UserDefaults.standard.string(forKey: "UserId") ?? "error")
        } catch {
            print("Error fetching user data: \(error)")
        }
        
        do {
            self.myProfile = try await ProfileService.getProfileById(profileId: UserDefaults.standard.string(forKey: "UserId") ?? "error")
        } catch {
            print("Error fetching user data: \(error)")
        }
        userName = myProfile?.name ?? "Default name"
        ProfileService.shared.retrievePhotosByUrl(photoUrl: (myProfile?.photoUrl)!) { retrievedImage in
            if let image = retrievedImage {
                self.profilePicture = image
            } else {
                print("Failed to retrieve the image.")
            }
        }
        isLoading = false
    }
    
    func fetchUserReviews() async {
        do {
            self.reviewsList = try await ReviewService.getReviewsByUserId(userId: UserDefaults.standard.string(forKey: "UserId") ?? "error")
        } catch {
            print("Error fetching user data: \(error)")
        }
        isLoading = false

    }
    func getUserEmail() -> String {
        return self.theUser?.email ?? "error: no email found"
    }
    
    func getUserReviews() -> [Review] {
        return self.reviewsList
    }
    
    func getMyProfile() async -> Profile {
        return self.myProfile ?? Profile(userId: "fake user", photoUrl: "fake photo", reviewList: ["fake review"], name: "fake name")
    }
    
    
    func sortReviewList() {
        sortViewModel.sortReviews(&reviewsList)
    }
    
    
    
}


