//
//  DetailPageResponse.swift
//  SmartPot
//
//  Created by Mark on 22.12.19.
//  Copyright © 2019 Mark. All rights reserved.
//

import Foundation

public struct DetailPageResponse: Codable {
    public let plant: Plant
    public let history: HistoryObject?
}
