//
//  HistoryResponse.swift
//  SmartPot
//
//  Created by Mark on 29.11.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import Foundation

public struct HistoryPageResponse: Codable {

    public let plantHistory: PlantHistory

    private enum CodingKeys: String, CodingKey {
        case plantHistory = "data"
    }
}

public struct PlantHistory: Codable {

    public let temperature: [Measurement]?
    public let humidityAir: [Measurement]?
    public let humiditySoil: [Measurement]?

    private enum CodingKeys: String, CodingKey {
        case temperature
        case humidityAir = "humidity_air"
        case humiditySoil = "humidity_soil"
    }
}
