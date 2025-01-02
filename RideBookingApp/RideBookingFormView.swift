//
//  RideBookingFormView.swift
//  RideBookingApp
//
//  Created by Okoi Victory Ebri on 02/01/2025.
//

import SwiftUI

#Preview {
    RideBookingFormView(showAvailableCars: .constant(true))
}


// MARK: - TASK 1
enum RideBookAlert {
    case invalidName
    case invalidPickupLocation
    case invalidDropoffLocation
    case pickUpAndDropOffLocationSame
    case valid
}

struct RideBookingFormView: View {
    @Binding var showAvailableCars: Bool
    @State private var name: String = ""
    @State private var pickupLocation: String = ""
    @State private var dropoffLocation: String = ""
    @State private var showAlert: Bool = false
    @State private var alertType: RideBookAlert = .invalidName
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Book A Ride")
                .font(.headline)
            ScrollView {
                VStack(alignment: .leading, spacing: 10.0) {
                    // MARK: - NAME
                    Text("Name")
                    TextField("Enter Your name", text: $name)
                    
                    Divider()
                    // MARK: - Pickup Location
                    Text("Pick-Up")
                    TextField("Where should we pick you up?", text: $pickupLocation)
                    Divider()
                    // MARK: - Drop-Off Location
                    Text("Drop-Off")
                    TextField("Enter your destination", text: $dropoffLocation)
                    
                }
            }
            Spacer()
            HStack(spacing: 10) {
                Button(action: {
                    showAvailableCars.toggle()
                }) {
                    Text("Show Available Cars")
                        .font(.callout)
                        .tint(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray)
                        )
                }
                Button(action: {
                    withAnimation {
                        switch validateInputs() {
                        case .invalidName:
                            alertType = .invalidName
                            showAlert = true
                        case .invalidPickupLocation:
                            alertType = .invalidPickupLocation
                            showAlert = true
                        case .invalidDropoffLocation:
                            alertType = .invalidDropoffLocation
                            showAlert = true
                        case .pickUpAndDropOffLocationSame:
                            alertType = .pickUpAndDropOffLocationSame
                            showAlert = true
                        case .valid:
                            alertType = .valid
                            showAlert = true
                        }
                    }
                }) {
                    Text("Book Ride")
                        .foregroundStyle(.white)
                        .padding()
                        .padding(.horizontal, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.yellow.opacity(0.89))
                        )
                }
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .invalidName:
                return Alert(
                    title: Text("Invalid Name"),
                    message: Text("The name field cannot be empty. Please enter your name to proceed."),
                    dismissButton: .default(Text("OK"))
                )
            case .invalidPickupLocation:
                return Alert(
                    title: Text("Invalid Pick-Up Location"),
                    message: Text("Please enter a valid pick-up location to book your ride."),
                    dismissButton: .default(Text("OK"))
                )
            case .invalidDropoffLocation:
                return Alert(
                    title: Text("Invalid Drop-Off Location"),
                    message: Text("Please enter a valid drop-off location to continue."),
                    dismissButton: .default(Text("OK"))
                )
            case .pickUpAndDropOffLocationSame:
                return Alert(
                    title: Text("Locations Cannot Be the Same"),
                    message: Text("Your pick-up and drop-off locations are identical. Please provide different locations."),
                    dismissButton: .default(Text("OK"))
                )
            case .valid:
                return Alert(
                    title: Text("Success"),
                    message: Text("Your Ride Has Successfully been booked"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            // MARK: - Task 2 Usage Example
            let result = calculateFare(distance: 12.5, carType: "Luxury")
            switch result {
            case .success(let fare):
                print("Total Fare: \(fare)")
            case .failure(let error):
                print("Error: \(error.description)")
            }
            
            let result2 = calculateFare(distance: -5, carType: "Economy")
            switch result2 {
            case .success(let fare):
                print("Total Fare: \(fare)")
            case .failure(let error):
                print("Error: \(error.description)")
            }
            
            let result3 = calculateFare(distance: 10, carType: "Unknown")
            switch result3 {
            case .success(let fare):
                print("Total Fare: \(fare)")
            case .failure(let error):
                print("Error: \(error.description)")
            }
        }
    }
    private func validateInputs() -> RideBookAlert {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .invalidName
        }
        else if pickupLocation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .invalidPickupLocation
        } else if dropoffLocation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .invalidDropoffLocation
        } else if pickupLocation == dropoffLocation {
            return .pickUpAndDropOffLocationSame
        } else {
            return .valid
        }
    }
}

