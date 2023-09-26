//
//  RootView.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/11/23.
//

import SwiftUI

class TabViewModel: ObservableObject {
    @Published var selectedTab = 1
}

struct RootView: View {
    @State private var showLoginView: Bool = false
    @State var changedReview: Bool = false
    let defaults = UserDefaults.standard
    @ObservedObject var tabViewModel = TabViewModel()
//    @StateObject private var tripPlanViewModel = TripPlanViewModel()

    var body: some View {
        ZStack {
            TabView(selection: $tabViewModel.selectedTab) {
                HomeTab(changedReview: $changedReview)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(1)
                TripTab(changedReview: $changedReview)
                    .tabItem {
                        Label("Trip", systemImage: "figure.walk")
                    }
                    .tag(2)
                ProfileTab(showLoginView: $showLoginView, changedReview: $changedReview)
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .tag(3)
                SettingTab(showLoginView: $showLoginView)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(4)
            }
            .tint(Color(red: 0.2, green: 0.3, blue: 0.9))
        }
        .onAppear() {
            let authUserId = defaults.object(forKey: "UserId")
            self.showLoginView = authUserId == nil ? true : false
        }
        .fullScreenCover(isPresented: $showLoginView) {
            NavigationStack {
                LoginView(showLoginView: $showLoginView, tabViewModel: tabViewModel)
            }
        }
        .transaction({ transaction in
            transaction.disablesAnimations = true
        })
    }
        
}

struct HomeTab: View {
    @Binding var changedReview: Bool
    var body: some View {
        ZStack {
            HomeView(changedReview: $changedReview)
        }
       
    }
}

struct TripTab: View {
    @Binding var changedReview: Bool
    var body: some View {
        ZStack {
            TripPlanningView(changedReview: $changedReview)
        }
    }
}
struct ProfileTab: View {
    @Binding var showLoginView: Bool
    @Binding var changedReview: Bool
    var body: some View {
        ZStack {
            ProfileView(showLoginView: $showLoginView, changedReview: $changedReview)
        }
    }
}
struct SettingTab: View {
    @Binding var showLoginView: Bool
    
    var body: some View {
        ZStack {
            SettingView(showLoginView: $showLoginView)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(TripPlanViewModel())
    }
}
