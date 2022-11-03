//
//  CompetitionDetailsVC+Model.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import Foundation

// MARK: - CompetitionDetailsResponse
struct CompetitionDetailsResponse: Codable {
    let id: Int?
    let area: Area?
    let name, code: String?
    let emblemURL: String?
    let plan: String?
    let currentSeason: Season?
    let seasons: [Season]?
    let lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case id, area, name, code
        case emblemURL = "emblemUrl"
        case plan, currentSeason, seasons, lastUpdated
    }
}

// MARK: - Season
struct Season: Codable {
    let id: Int
    let startDate, endDate: String
    let currentMatchday: Int?
    let winner: Winner?
}

// MARK: - TeamsResponse
struct TeamsResponse: Codable {
    let count: Int?
    let filters: Filters?
    let competition: Competition?
    let season: Season?
    let teams: [Team]?
}

// MARK: - Team
struct Team: Codable {
    let id: Int
    let area: Area
    let name: String
    let shortName, tla: String?
    let crestURL: String
    let address: String
    let phone: String?
    let website: String?
    let email: String?
    let founded: Int?
    let clubColors, venue: String?
    let lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case id, area, name, shortName, tla
        case crestURL = "crestUrl"
        case address, phone, website, email, founded, clubColors, venue, lastUpdated
    }
}
