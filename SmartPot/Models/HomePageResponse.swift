//
//  HomePageResponse.swift
//  SmartPot
//
//  Created by Mark on 14.11.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import Foundation

public struct HomePageResponse: Codable {
    public let plants: [Plant]?

    private enum CodingKeys: String, CodingKey {
        case plants = "data"
    }
}
