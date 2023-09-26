//
//  LoginView.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI

struct LoginView: View {
    @State private var showingRegistrationForm = false
    @Binding var showLoginView: Bool
    
    @StateObject private var viewModel = LoginViewModel()
    @ObservedObject var tabViewModel = TabViewModel()
    @EnvironmentObject var tripPlanViewModel: TripPlanViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Image("login")
                    .resizable()
                    .frame(width: 330, height: 300)
                
                TextField("Email", text: $viewModel.email)
                    .multilineTextAlignment(TextAlignment.center)
                    .frame(width: 300, height: 50)
                    .background(Color(red: 0.8, green: 0.9, blue: 1).opacity(0.8))
                    .cornerRadius(30)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.all)
                
                SecureField("Password", text: $viewModel.password)
                    .multilineTextAlignment(TextAlignment.center)
                    .frame(width: 300, height: 50)
                    .background(Color(red: 0.8, green: 0.9, blue: 1).opacity(0.8))
                    .cornerRadius(30)
                    .padding()
                
                Button("Login") {
                    Task {
                        try await viewModel.signIn()
                    }
                }
                .bold()
                .foregroundColor(.white)
                .frame(width: 120, height: 45)
                .background(Color(red: 0.4, green: 0.5, blue: 1))
                .cornerRadius(10)
                .padding()
                
                Button("Don't have an account? \nRegister Here") {
                    showingRegistrationForm = true
                }
                .font(.footnote)
                .foregroundColor(Color(red: 0.4, green: 0.5, blue: 1))
                .padding()
                .sheet(isPresented: $showingRegistrationForm) {
                    RegistrationView()
                }
            }
            .padding()
            .onChange(of: viewModel.isLoggedIn) { isLoggedIn in
                if isLoggedIn {
                    showLoginView = false
                    tabViewModel.selectedTab = 1
                    Task {
                        await tripPlanViewModel.loadTrips(userId: UserDefaults.standard.object(forKey: "UserId") as? String ?? "")
                    }
                } else {
                    print("isLoggedIn function failed")
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Login Failed"),
                    message: Text("Incorrect login credentials, please try again"),
                    dismissButton: .default(Text("Dismiss"))
                )
            }
        }
    }
}


//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(showLoginView: .constant(true))
//    }
//}
