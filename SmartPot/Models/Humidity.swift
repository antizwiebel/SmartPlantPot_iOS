//
//  Humidity.swift
//  SmartPot
//
//  Created by Mark on 13.11.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import Foundation

public struct Humidity: Codable {
    public let id: Int
    public let date: String?
    public let plant: Plant
    public var value: Float
}
