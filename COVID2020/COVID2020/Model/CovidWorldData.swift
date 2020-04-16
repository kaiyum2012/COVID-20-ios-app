//
//  CovidWorldData.swift
//  COVID2020
//
//  Created by Student on 2020-04-15.
//  Copyright © 2020 Kaiyum. All rights reserved.
//
import Foundation

// MARK: - CovidWordData
struct CovidWordData: Codable {
    var id, displayName: String
    var areas: [CovidWordData]
    var totalConfirmed,totalDeaths, totalRecovered, totalRecoveredDelta, totalDeathsDelta: Int?
    var totalConfirmedDelta: Int?
    var lastUpdated: String?
    var lat, long: Double?
    var parentID: String?
}


