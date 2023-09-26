//
//  EditTripSheetView.swift
//  TripAdvisor
//
//  Created by Janine Chen on 8/12/23.
//

import SwiftUI

struct EditTripSheetView: View {
    @EnvironmentObject var tripPlanViewModel: TripPlanViewModel
    @Binding var isEdited: Bool
    @State var alertMessage:String
    @State var isDeleteAlert: Bool
    @State var isEditAlert: Bool
    @Binding var trip: Trip
    @State private var editedTrip: Trip
    
    init(isEdited: Binding<Bool>, alertMessage: String, isDeleteAlert: Bool, isEditAlert: Bool, trip: Binding<Trip>) {
        _isEdited = isEdited
        _alertMessage = State(initialValue: alertMessage)
        _isDeleteAlert = State(initialValue: isDeleteAlert)
        _isEditAlert = State(initialValue: isDeleteAlert)
        _trip = trip
        _editedTrip = State(initialValue: trip.wrappedValue)
    }
    
    var body: some View {
        VStack{
            HStack{
                Text("Edit your trip")
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
            
            TextField("", text: $editedTrip.name)
            .frame(width: 360, height: 50)
            .border(.gray)
            HStack{
                Text("How many members?")
                    .bold()
                    .font(.title3)
                Spacer()
            }
            .padding(.horizontal)
            
            TextField("How many members?", text: Binding(
                        get: { String(editedTrip.members) },
                        set: { if let newValue = Int($0) { editedTrip.members = newValue } }
                    ))
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
                Toggle(isOn: $editedTrip.isPrivate){
                    Label("Private trip", systemImage: "figure.2.and.child.holdinghands")
                }
                Spacer()
            }
            .padding(.horizontal)
            
            HStack{
                Button{
                    isDeleteAlert = true
                }
                label: {
                    Text("Delete the trip")
                        .bold()
                        .frame(width: 150, height: 40)
                        .foregroundColor(.red)
                        .background(Color.white)
                }
                .padding(.all)
                .alert(isPresented: $isDeleteAlert){
                    Alert(
                        title: Text("Warning"),
                        message: Text("Are you sure you want to delete this trip?"),
                        primaryButton: .destructive(
                            Text("Delete"),
                            action: {
                                tripPlanViewModel.deleteTrip(editedTrip, tripPlanViewModel)
                                isEdited = false
                            }
                        ),
                        secondaryButton: .default(
                            Text("Dismiss"),
                            action: {
                                isEdited = false
                            }
                        )
                    )
                }
                
                Button{
                    if tripPlanViewModel.updateTrip(editedTrip, &trip, tripPlanViewModel, editedTrip.name, String(editedTrip.members), &alertMessage, &isEditAlert){
                        isEdited = false
                        Task {
                            await tripPlanViewModel.updateTripinFirebase(trip)
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
                .alert(isPresented: $isEditAlert){
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
            }

        }
        .presentationDetents([.medium])
    }
}

//struct EditTripSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        let tripPlanViewModel = TripPlanViewModel()
//        let bindingTrip = Binding<Trip>(
//            get: { tripPlanViewModel.trips[0] },
//            set: { tripPlanViewModel.trips[0] = $0 }
//        )
//
//        return EditTripSheetView(
//            isEdited: .constant(false),
//            alertMessage: "",
//            isDeleteAlert: false,
//            isEditAlert: false,
//            trip: bindingTrip
//        )
//        .environmentObject(TripPlanViewModel())
//    }
//}
