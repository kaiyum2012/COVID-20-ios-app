//
//  CovidWorldData.swift
//  COVID2020
//
//  Created by Student on 2020-04-15.
//  Copyright © 2020 Kaiyum. All rights reserved.
//
import Foundation

// MARK: - CovidWordData
struct CovidWordData: Codable , Comparable {
    static func < (lhs: CovidWordData, rhs: CovidWordData) -> Bool {
        if let lhs = lhs.totalConfirmed, let rhs = rhs.totalConfirmed{
            return lhs > rhs ? true : false
        }
        return false
    }
    
    var id, displayName: String
    var areas: [CovidWordData]
    var totalConfirmed,totalDeaths, totalRecovered, totalRecoveredDelta, totalDeathsDelta: Int?
    var totalConfirmedDelta: Int?
    var lastUpdated: String?
    var lat, long: Double?
    var parentID: String?
}


