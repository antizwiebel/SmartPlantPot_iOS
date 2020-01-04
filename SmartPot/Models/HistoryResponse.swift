//
//  HistoryResponse.swift
//  SmartPot
//
//  Created by Mark on 29.11.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import Foundation

public struct HistoryPageResponse: Codable {
    public let historyObjects: [HistoryObject]
}

public struct HistoryObject: Codable {
    public var name: String?
    public let id: Int
    public let dateAdded: Int?
    public var temperatureTreshold: Float?
    public var humidityTreshold: Float?
    public let ownerId: Int
    public var active: Bool?
    public let temperatures: [DataPoint]?
    public let water: [DataPoint]?
    public let humidities: [DataPoint]?

    private enum CodingKeys: String, CodingKey {
        case id
        case dateAdded
        case name
        case active, temperatureTreshold, humidityTreshold
        case ownerId
        case water, temperatures, humidities
    }
}

public struct DataPoint: Codable, Comparable {
    public static func < (lhs: DataPoint, rhs: DataPoint) -> Bool {
        lhs.date < rhs.date
    }


    public let value: Float
    public let date: Int

    private enum CodingKeys: String, CodingKey {
        case value
        case date
    }
}
