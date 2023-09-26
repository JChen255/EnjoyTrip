//
//  SettingView.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var viewModel: SettingViewModel
    @Binding var showLoginView: Bool
    let currencies = Currency.allCases
    let defaults = UserDefaults.standard
    @State private var selectedCurrency: Currency = .usd
    @State private var rating: Int = 0
    @State private var comments: String = ""
    @State private var isFeedbackSubmitted = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                } else {
                    Text("Loading...")
                    Text("Loading...")
                }
                
                List {
                    Section(header: Text("Select Currency")) {
                        ForEach(currencies, id: \.self) { currency in
                            Button(action: {
                                selectedCurrency = currency
                                viewModel.selectedCurrency = currency
                                viewModel.saveSelectedCurrency(userId: viewModel.user?.userId ?? "")
                            }) {
                                HStack {
                                    Text(currency.rawValue)
                                    Spacer()
                                    if selectedCurrency == currency {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Feedback")) {
                        VStack(alignment: .center) {
                            HStack {
                                Text("Give us a rating: ")
                                Spacer()
                                ForEach(1..<6, id: \.self) { number in
                                    Image(systemName: rating >= number ? "star.fill" : "star")
                                        .foregroundColor(rating >= number ? .yellow : .gray)
                                        .onTapGesture {
                                            rating = number
                                        }
                                }
                            }
                            .padding(.top,5)
                            Spacer()
                            
                            VStack {
                                TextEditor(text: $comments)
                                    .frame(height: 100)
                                    .background(Color.gray)
                                    .foregroundColor(Color.blue)
                                    .cornerRadius(8)
                            }
                            .padding(.bottom,5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                            
                            Button("Submit Feedback") {
                                FeedbackService.shared.submitFeedback(rating: rating, comments: comments, userId: viewModel.user?.userId ?? "") { error in
                                    if let error = error {
                                        print("Error submitting feedback: \(error)")
                                    } else {
                                        print("Feedback submitted successfully!")
                                        rating = 0
                                        comments = ""
                                        isFeedbackSubmitted = true
                                    }
                                }
                                
                            }
                            .frame(width: 200, height: 30)
                            .padding(.vertical,5)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            
                            Spacer()
                            
                        }
                    }
                }
                
                Spacer()
                
                Button("Log out") {
                    Task {
                        do {
                            try viewModel.logOut()
                            showLoginView = true
                        } catch {
                            print(error)
                        }
                    }
                }
                .foregroundColor(.red)
                .frame(width: 100, height: 30)
                .padding(.bottom, 15)
                
                // TODO: add an extra layer of protection to avoid false operation
//                Button("Delete Account") {
//                    Task {
//                        do {
//                            try await viewModel.deleteUser()
//                            showLoginView = true
//                        } catch {
//                            print(error)
//                        }
//                    }
//                }
//                .foregroundColor(.red)
//                .frame(width: 100, height: 30)
//                .padding(.bottom, 15)
                
                
            }
            .task {
                try? await viewModel.loadCurrentUser()
            }
            .onAppear {
                selectedCurrency = viewModel.loadSelectedCurrency(userId: viewModel.user?.userId ?? "")
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Text("Welcome, \(viewModel.user?.userName ?? "")")
                    .font(.headline)
                    .foregroundColor(.primary),
                trailing: EmptyView()
            )
            
            
            .alert(isPresented: $isFeedbackSubmitted) {
                Alert(
                    title: Text("Feedback Submitted"),
                    message: Text("Thank you for your feedback!"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(showLoginView: .constant(false))
    }
}
