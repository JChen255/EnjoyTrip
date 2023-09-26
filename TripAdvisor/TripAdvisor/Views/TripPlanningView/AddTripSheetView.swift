//
//  TripPlanningSheetView.swift
//  TripAdvisor
//
//  Created by Janine Chen on 8/12/23.
//

import SwiftUI

struct AddTripSheetView: View {
    @EnvironmentObject var tripPlanViewModel: TripPlanViewModel
    @Binding var isPresented: Bool
    @State var alertMessage:String
    @State var isAlert:Bool
    let defaults = UserDefaults.standard
    
    var body: some View{
        VStack{
            HStack{
                Text("Add a new trip")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding(.all)
            HStack{
                Text("Trip name")
                    .bold()
                    .font(.title3)
                Spacer()
            }
            .padding(.horizontal)
            TextField("", text: $tripPlanViewModel.tripName)
            .frame(width: 360, height: 50)
            .border(.gray)
            HStack{
                Text("How many members?")
                    .bold()
                    .font(.title3)
                Spacer()
            }
            .padding(.horizontal)
            TextField("", text: $tripPlanViewModel.numOfMember)
            .frame(width: 360, height: 50)
            .border(.gray)
            HStack{
                Text("Privacy of the trip?")
                    .bold()
                    .font(.title3)
                Spacer()
            }
            .padding(.horizontal)
            
            HStack(alignment:.center){
                Spacer()
                Toggle(isOn: $tripPlanViewModel.isPublic){
                    Label("Private trip", systemImage: "figure.2.and.child.holdinghands")
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Button{
                if tripPlanViewModel.addNewTrip(tripPlanViewModel.tripName, tripPlanViewModel.numOfMember, tripPlanViewModel.isPublic, [], tripPlanViewModel, &isPresented, &alertMessage, &isAlert){
                    Task {
                        try await tripPlanViewModel.addNewTriptoFirebase(tripPlanViewModel.tripName, tripPlanViewModel.numOfMember, tripPlanViewModel.isPublic, (defaults.object(forKey: "UserId") as? String)!, [])
                    }
                }
            }
            label: {
                Text("Save")
                    .bold()
                    .frame(width: 100, height: 40)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(20)
            }
            .padding(.all)
            .alert(isPresented: $isAlert){
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .presentationDetents([.medium])
    }
}


struct TripPlanningSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripSheetView(isPresented: .constant(false), alertMessage: "", isAlert: false)
            .environmentObject(TripPlanViewModel())
    }
}
