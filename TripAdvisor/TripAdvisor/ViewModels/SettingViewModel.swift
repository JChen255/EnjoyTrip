//
//  SettingViewModel.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI

@MainActor
final class SettingViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published var selectedCurrency: Currency = .usd
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationService.shared.getAuthenticatedUser()
        self.user = try await UserService.shared.getUser(userId: authDataResult.uid)
    }
    
    func logOut() throws {
        try AuthenticationService.shared.signOut()
        UserDefaults.standard.removeObject(forKey: "UserId")
    }
    
    func deleteUser() async throws {
        try await UserService.shared.deleteUser(userId: self.user?.userId ?? "")
        UserDefaults.standard.removeObject(forKey: "UserId")
        try AuthenticationService.shared.deleteUser()
    }
    
    func saveSelectedCurrency(userId: String) {
        UserDefaults.standard.set(selectedCurrency.rawValue, forKey: userId)
    }
    
    func loadSelectedCurrency(userId: String) -> Currency {
        guard let rawCurrency = UserDefaults.standard.string(forKey: userId),
              let currency = Currency(rawValue: rawCurrency) else {
            return .usd
        }
        return currency
    }
    
}
