//
//  RegisterView.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI

struct RegistrationView: View {
    
    @StateObject private var viewModel = RegistrationViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Let's explore the world!")
                .bold()
                .font(.title)
            Image("register")
                .resizable()
                .frame(width: 370, height: 270)
            
            TextField("Email", text: $viewModel.email)
                .multilineTextAlignment(TextAlignment.center)
                .frame(width: 300, height: 50)
                .background(Color(red: 0.8, green: 0.9, blue: 1).opacity(0.8))
                .cornerRadius(30)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            TextField("Username", text: $viewModel.userName)
                .multilineTextAlignment(TextAlignment.center)
                .frame(width: 300, height: 50)
                .background(Color(red: 0.8, green: 0.9, blue: 1).opacity(0.8))
                .cornerRadius(30)
            
            TextField("Location", text: $viewModel.location)
                .multilineTextAlignment(TextAlignment.center)
                .frame(width: 300, height: 50)
                .background(Color(red: 0.8, green: 0.9, blue: 1).opacity(0.8))
                .cornerRadius(30)
            
            SecureField("Password", text: $viewModel.password)
                .multilineTextAlignment(TextAlignment.center)
                .frame(width: 300, height: 50)
                .background(Color(red: 0.8, green: 0.9, blue: 1).opacity(0.8))
                .cornerRadius(30)
            
            Button("Register") {
                Task {
                    do {
                        let success = try await viewModel.signUp()
                        if success {
                            viewModel.dismiss = true
                        }
                    } catch {
                        viewModel.alertMessage = error.localizedDescription
                        viewModel.showAlert = true
                        viewModel.dismiss = false
                    }
                    if viewModel.dismiss {
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }
                }
                
            }
            .bold()
            .foregroundColor(.white)
            .frame(width: 120, height: 45)
            .background(Color(red: 0.4, green: 0.5, blue: 1))
            .cornerRadius(10)
            .padding()
        }
        .padding(.all)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Registration Error"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK")) {
//                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}
