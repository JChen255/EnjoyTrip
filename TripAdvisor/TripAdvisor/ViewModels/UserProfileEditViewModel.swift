//
//  UserProfileEditViewModel.swift
//  TripAdvisor
//
//  Created by Weiqi Zhuang on 8/17/23.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class UserProfileEditViewModel: ObservableObject {
    @Published var profile: Profile?
    @Published var avatarImageSelection: PhotosPickerItem? = nil
    @Published var avatarImage: Image = Image(systemName: "circle.dashed")
    @Published var imageToUpload: UIImage?
    @Published var name: String = ""
    
    func loadProfile(profile: Profile) {
        self.profile = profile
        self.name = profile.name
        
    }
    func updateProfile() async  {
        print("clicked update")
        // Profile service to update
        do {
            if let userId = profile?.userId {
                try await ProfileService.shared.updateProfileNameById(userId: userId, name: name)
                ProfileService.shared.uploadProfilePicture(userId: userId, selectedImage: imageToUpload)
                let path = "images/\(userId).jpg"
                print("photoUrl is \(path)")
                try await ProfileService.shared.updateProfilePhotoById(userId: userId, photoUrl: path)
                ProfileService.shared.retrievePhotosByUrl(photoUrl: path) { retrievedImage in
                    if let image = retrievedImage {
                        print("Successfully retrieved the image.")
                        self.avatarImage = image
                    } else {
                        print("Failed to retrieve the image.")
                    }
                    
                }
            } else {
                print("Invalid userId when updating profile")
            }
        } catch {
            print("Error updating profile \(error)")
        }
        
    }
    
    func deleteProfile() {
        // SettingViewModel delete user
    }
    
    func deleteUser() async throws {
        try await UserService.shared.deleteUser(userId: self.profile?.userId ?? "")
        UserDefaults.standard.removeObject(forKey: "UserId")
        try AuthenticationService.shared.deleteUser()
    }
    
    
}
