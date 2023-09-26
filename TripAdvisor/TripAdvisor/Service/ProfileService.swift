//
//  ProfileService.swift
//  TripAdvisor
//
//  Created by Weiqi Zhuang on 8/16/23.
//

import Foundation
import SwiftUI

final class ProfileService {
    
    static let shared = ProfileService()
    private init() { }
    
    static func getAllProfiles() async throws -> [Profile]? {
        let snapshot = try await profileCollection.getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: Profile.self, decoder: firebaseDecoder)
        }
    }
    
    static func getProfileById(profileId: String) async throws -> Profile? {
        return try? await profileCollection.document(profileId).getDocument().data(as: Profile.self, decoder: firebaseDecoder)
    }
    
    static func addReviewToProfileById(profileId:String, reviewId:String) async throws {
        var profileData = [String: Any]()
        let document = try await profileCollection.document(profileId).getDocument()
        
        if var reviews = document.data()?["review_list"] as? [String] {
            reviews.append(reviewId)
            profileData["review_list"] = reviews
        } else {
            profileData["review_list"] = [reviewId]
        }
        
        try await profileCollection.document(profileId).updateData(profileData)
    }
    
    static func addNewProfile(profile: Profile) throws {
        try profileCollection.document(profile.userId).setData(from: profile, merge: false, encoder: firebaseEncoder)
    }
    
    func updateProfilePhotoById(userId: String, photoUrl: String) async throws {
        try await profileCollection.document(userId).updateData(["photo_url" : photoUrl])
    }
    
    func updateProfileNameById(userId: String, name: String) async throws {
        try await profileCollection.document(userId).updateData(["name" : name])
        try await UserService.shared.updateUserNameById(userId: userId, name: name)
    }
    
    
    func uploadProfilePicture(userId: String, selectedImage: UIImage?) {
        guard selectedImage != nil else {
            return
        }
        // Create storage reference
        
        // Turn our image into data
        guard let imageData = selectedImage!.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        // Specify the file path and name
        let path = "images/\(userId).jpg"
        let fileRef = storageRef.child(path)
        // Upload that data
        let uploadTask = fileRef.putData(imageData) { metaData, error in
            
            if error == nil && metaData != nil {
                // success
                // Save a reference to the file in Firestore DB
                imageCollection.document(userId).setData(["url" : path])
            }
            
            
        }
    }

    func retrievePhotosByUrl(photoUrl: String, completion: @escaping (Image?) -> Void) {
        let group = DispatchGroup()
        var image: Image?
        // Specify the path
        let fileRef = storageRef.child(photoUrl)
        
        // Retrieve the data
        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if error == nil && data != nil {
                group.enter()
                if let uiImage = UIImage(data: data!) {
                    image = Image(uiImage: uiImage)
                    completion(image)
                    group.leave()
                } else {
                    print("failed to get uiImage")
                    image = Image(systemName: "exclamationmark.shield")
                }
            } else {
                print("Error retreiving image by url \(error!)")
                completion(nil)
                return
            }
        }
    }

}
