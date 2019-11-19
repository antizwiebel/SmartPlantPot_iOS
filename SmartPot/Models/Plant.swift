//
//  Plant.swift
//  SmartPot
//
//  Created by Mark on 13.11.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import Foundation

public enum PlantStatus: Int, Codable {
    case red = 0
    case yellow = 1
    case green = 2
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
    public var active: Bool?

    private enum CodingKeys: String, CodingKey {
        case id
        case dateAdded
        case name
        case owner
        case status
        case active, temperatureTreshold, humidityTreshold
        case ownerId
    }
}
