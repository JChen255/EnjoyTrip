//
//  LoginViewModel.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {

    @Published var email = ""
    @Published var password = ""
    @Published var isLoggedIn = false
    @Published var showAlert = false
    let defaults = UserDefaults.standard
    
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
    
        Task {
            do {
                let authDataResult = try await AuthenticationService.shared.signInUser(email: email, password: password)
                isLoggedIn = true
                defaults.set(authDataResult?.uid, forKey: "UserId")
            } catch {
                showAlert = true
                print("Error: \(error)")
            }
        }
    }
}
