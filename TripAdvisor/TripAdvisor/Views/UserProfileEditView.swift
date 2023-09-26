//
//  UserProfileEditView.swift
//  TripAdvisor
//
//  Created by wade hu on 8/15/23.
//

import SwiftUI
import PhotosUI

struct UserProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var editedName:String = ""
    @ObservedObject var profileViewModel: ProfileViewModel
    @StateObject var viewModel = UserProfileEditViewModel()
    @State var imageSelection: PhotosPickerItem?
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var showAlert = false
    @Binding var showLoginView: Bool
    
    var body: some View {
        
        VStack(alignment: .center){
            if viewModel.profile != nil {
                Spacer()
                PhotosPicker(selection: $viewModel.avatarImageSelection, matching: .images) {
                    VStack{
                        viewModel.avatarImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .foregroundColor(Color(hue: 0.591, saturation: 0.068, brightness: 0.242))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                            .padding(.top, 20)
                        
                        Text("Tap to change profile picture")
                    }
                }
                .onChange(of: viewModel.avatarImageSelection) { _ in
                    Task {
                        if let data = try? await viewModel.avatarImageSelection?.loadTransferable(type: Data.self) {
                            print("selected data: \(data) \n")
                            if let uiImage = UIImage(data: data) {
                                viewModel.imageToUpload = uiImage
                                viewModel.avatarImage = Image(uiImage: uiImage)
                                return
                            }
                        }
                        print("Failed")
                    }
                }
                
                Spacer()
                
                VStack{
                    Text("Edit name below")
                        .font(.headline)
                        .padding(.top)
                    
                    TextField("type in here...", text: $viewModel.name)
                        .frame(height: 55)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal], 4)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                        .padding([.horizontal], 24)
                    
                    
                }
                
                Spacer()
                Button {
                    profileViewModel.userName = viewModel.name
                    profileViewModel.profilePicture = Image(uiImage: viewModel.imageToUpload ?? UIImage(systemName: "circle.dashed")!)
                    Task {
                        await viewModel.updateProfile()
//                        await profileViewModel.fetchUserData()
                        dismiss()
                    }
                } label: {
                    Text("Update")
                        .padding(.horizontal, 8)
                        .frame(height: 44)
                        .foregroundColor(.white)
                        .background(Color(red: 0.065, green: 0.64, blue: 0.819))
                        .cornerRadius(8)
                }
                Spacer()
                Button {
                    showAlert = true
                }label: {
                    Text("Delete Account")
                        .padding(.horizontal, 8)
                        .frame(height: 44)
                        .foregroundColor(.white)
                        .background(Color(red: 1, green: 0, blue: 0))
                        .cornerRadius(8)
                }
                
                Spacer()
            } else {
                Text("Loading profile")
            }
        }.onAppear{
            if let profile = profileViewModel.myProfile{
                viewModel.loadProfile(profile: profile)
            } else {
                print("No profile found")
            }
            
        }.task {
            if let photoUrl = viewModel.profile?.photoUrl {
                ProfileService.shared.retrievePhotosByUrl(photoUrl: photoUrl) {
                    retrievedImage in
                        if let image = retrievedImage {
                            print("Successfully retrieved the image.")
                            self.viewModel.avatarImage = image
                        } else {
                            print("Failed to retrieve the image.")
                        }
                }
            } else {
                print("No photoURL found in profile")
            }
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    Task {
                        do {
                            try await viewModel.deleteUser()
                            showLoginView = true
                            dismiss()
                        } catch {
                            print("Error deleting user: \(error)")
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
        
    }
}

//struct UserProfileEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserProfileEditView()
//    }
//}
