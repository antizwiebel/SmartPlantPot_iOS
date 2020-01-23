//
//  Plant.swift
//  SmartPot
//
//  Created by Mark on 13.11.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import Foundation

public enum PlantStatus: String, Codable {
    case red
    case yellow
    case green
}

public struct Plant: Codable {
    public var name: String?
    public let id: Int
    public let dateAdded: String?
    public var temperatureTreshold: Float?
    public var humidityTreshold: Float?
    public let owner: User?
    public let ownerId: Int
    public var status: PlantStatus?
    public var active: Int?
    public let temperature: Float?
    public var humidityAir: Float?
    public var humiditySoil: Float?
    public let profileImageId: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case dateAdded = "date_added"
        case name
        case owner
        case status
        case active
        case temperatureTreshold = "temperature_treshold"
        case humidityTreshold = "humidity_treshold"
        case ownerId = "owner_id"
        case temperature = "curr_temperature"
        case profileImageId = "profile_image_id"
        case humidityAir = "curr_humidity_air"
        case humiditySoil = "curr_humidity_soil"
    }
}
