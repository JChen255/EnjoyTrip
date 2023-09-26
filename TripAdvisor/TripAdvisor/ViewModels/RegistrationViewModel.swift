//
//  RegistrationViewModel.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI

@MainActor
final class RegistrationViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var userName = ""
    @Published var location = ""
    @Published var isRegistered = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var dismiss = false
    
    func signUp() async throws -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please enter email and password."
            showAlert = true
            dismiss = false
            return false
        }
        do {
            let AuthDataResult = try await AuthenticationService.shared.createUser(email: email, password: password)
            isRegistered = true
            let user = DBUser(auth: AuthDataResult, userName: userName)
            try await UserService.shared.createNewUser(user: user)
            try ProfileService.addNewProfile(profile: Profile(user: user))
        } catch {
            alertMessage = "Registration failed: \(error.localizedDescription)"
            showAlert = true
            dismiss = false
            return false
        }
        return true
    }
}
