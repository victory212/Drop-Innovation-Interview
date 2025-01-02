//
//  ContentView.swift
//  RideBookingApp
//
//  Created by Okoi Victory Ebri on 31/12/2024.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var showAvailableCars: Bool = false
    var body: some View {
        VStack {
            RideBookingFormView(showAvailableCars: $showAvailableCars)
        }
        .sheet(isPresented: $showAvailableCars) {
            CarListView()
        }
    }
}

#Preview {
    ContentView()
}
