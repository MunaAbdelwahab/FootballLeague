//
//  TeamsVC+Model.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import Foundation

// MARK: - TeamDetailsResponse
struct TeamDetailsResponse: Codable {
    let id: Int
    let area: Area
    let name, shortName, tla: String
    let crestURL: String
    let address, phone: String
    let website: String
    let email: String
    let founded: Int
    let clubColors, venue: String
    let lastUpdated: String?
    let squad: [Squad]?
    
    enum CodingKeys: String, CodingKey {
        case id, area, name, shortName, tla
        case crestURL = "crestUrl"
        case address, phone, website, email, founded, clubColors, venue, lastUpdated, squad
    }
}

// MARK: - Squad
struct Squad: Codable {
    let id: Int
    let name, position: String
    let dateOfBirth: String
    let countryOfBirth, nationality, role: String
}
