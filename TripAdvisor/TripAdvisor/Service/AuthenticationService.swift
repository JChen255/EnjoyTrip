//
//  AuthenticationService.swift
//  TripAdvisor
//
//  Created by Weiqi Zhuang on 8/12/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    let displayName: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.displayName = user.displayName
    }
}

final class AuthenticationService {
    
    static let shared = AuthenticationService()
    private init() { }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel? {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func deleteUser() throws {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print("Error deleting user: \(error.localizedDescription)")
            } else {
                print("User deleted successfully")
            }
        }
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
}
