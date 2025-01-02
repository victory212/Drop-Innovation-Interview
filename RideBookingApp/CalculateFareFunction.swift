//
//  CalculateFareFunction.swift
//  RideBookingApp
//
//  Created by Okoi Victory Ebri on 02/01/2025.
//

import Foundation

// MARK: - TASK 2
enum CarType: String {
    case economy = "Economy"
    case luxury = "Luxury"
    case suv = "SUV"
}

enum FareCalculationResult: Error, CustomStringConvertible {
    case negativeDistanceError
    case unSuppportedCarType(String)
    
    var description: String {
        switch self {
        case .negativeDistanceError:
            return "Distance Cannot be negative."
        case .unSuppportedCarType(let carType):
            return "Unsupported car type '\(carType)'. Please choose Economy, Luxury, or SUV."
        }
    }
}

func calculateFare(distance: Double, carType: String) -> Result<Double, FareCalculationResult> {
    guard distance >= 0 else {
        return .failure(.negativeDistanceError)
    }
    
    guard let carCategory = CarType(rawValue: carType) else {
        return .failure(.unSuppportedCarType(carType))
    }
    
    let farePerKm: Double
    switch carCategory {
    case .economy:
        farePerKm = 10.0
    case .luxury:
        farePerKm = 20.0
    case .suv:
        farePerKm = 15.0
    }
    
    let totalFare = distance * farePerKm
    return .success(totalFare)
}
