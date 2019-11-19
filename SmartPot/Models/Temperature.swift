//
//  Temperature.swift
//  SmartPot
//
//  Created by Mark on 13.11.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import Foundation

public enum TemperatureUnit: String, Codable {
    case celsius
    case fahrenheit
}

public struct Temperature: Codable {
    public let id: Int
    public let date: String?
    public let plant: Plant
    public var unitOfMeasurement: TemperatureUnit
    public let value: Float
}
