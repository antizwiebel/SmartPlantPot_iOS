//
//  Measurement.swift
//  SmartPot
//
//  Created by Mark on 13.11.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import Foundation

public enum MeasurementUnit: String, Codable {
    case celsius
    case percent
    case fahrenheit
}

public enum MeasurementType: String, Codable {
    case temperature
    case humidityAir = "humidity_air"
    case humiditySoil = "humidity_soil"
}

public struct Measurement: Codable, Comparable {

    public static func < (lhs: Measurement, rhs: Measurement) -> Bool {
    lhs.date < rhs.date
    }

    public let id: Int
    public let date: Date
    public let plantId: Int
    public let unit: MeasurementUnit
    public let value: Float
    public var type: MeasurementType

    private enum CodingKeys: String, CodingKey {
        case id
        case date
        case plantId = "plant_id"
        case unit
        case value
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)

        let decodedDateString = try container.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        date = dateFormatter.date(from: decodedDateString) ?? Date()

        plantId = try container.decode(Int.self, forKey: .plantId)
        unit = try container.decode(MeasurementUnit.self, forKey: .unit)
        value = try container.decode(Float.self, forKey: .value)
        type = try container.decode(MeasurementType.self, forKey: .type)
    }
}
