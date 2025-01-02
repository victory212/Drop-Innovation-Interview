//
//  AvailableCarsView.swift
//  RideBookingApp
//
//  Created by Okoi Victory Ebri on 02/01/2025.
//

import Foundation
import SwiftUI

// MARK: - TASK 3
struct Car: Codable {
    let id: Int
    let name: String
    let fare: Double
    let type: String
}


struct CarListView: View {
    @State private var cars: [Car] = []
    @State private var isLoading = true
    @State private var errorMessage: String?    // The Error messages will be used to show Descriptive Banners for a better user experience
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading cars...")
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    CarTableView(cars: $cars)
                }
            }
            .navigationTitle("Available Cars")
            .onAppear {
                fetchCars()
            }
        }
    }
    
    private func fetchCars() {
        guard let url = URL(string: "https://run.mocky.io/v3/242a7a65-ce2e-48df-a5ae-7ac88400a5e8") else {
            errorMessage = "Invalid API URL."
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Failed to fetch cars: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received from the server."
                }
                return
            }
            
            do {
                let fetchedCars = try JSONDecoder().decode([Car].self, from: data)
                DispatchQueue.main.async {
                    cars = fetchedCars
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Failed to parse data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

struct CarTableView: UIViewRepresentable {
    @Binding var cars: [Car]
    
    class Coordinator: NSObject, UITableViewDataSource {
        var cars: [Car]
        
        init(cars: [Car]) {
            self.cars = cars
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return cars.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "CarCell")
            let car = cars[indexPath.row]
            cell.textLabel?.text = car.name
            cell.detailTextLabel?.text = "\(car.type) - N\(car.fare)"
            return cell
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(cars: cars)
    }
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = context.coordinator
        tableView.allowsSelection = false
        tableView.allowsFocus = false
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        context.coordinator.cars = cars
        uiView.reloadData()
    }
}

