//
//  DetailPageResponse.swift
//  SmartPot
//
//  Created by Mark on 22.12.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import Foundation

public struct DetailPageResponse: Codable {
    public var plant: Plant
    public var history: PlantHistory?
}
