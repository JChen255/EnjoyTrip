//
//  UserService.swift
//  TripAdvisor
//
//  Created by Weiqi Zhuang on 8/14/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserService {
    
    static let shared = UserService()
    private init() { }
    
    func createNewUser(user: DBUser) async throws {
        try userCollection.document(user.userId).setData(from: user, merge: false, encoder: firebaseEncoder)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        return try await userCollection.document(userId).getDocument(as: DBUser.self, decoder: firebaseDecoder)
    }
    
    func deleteUser(userId: String) async throws {
        do {
            try await userCollection.document(userId).delete()
        } catch {
            print("Error when deleting user:\(userId), \(error)")
        }
    }
    
    func updateUserNameById(userId: String, name: String) async throws {
        try await userCollection.document(userId).updateData(["user_name" : name])
    }
}
