//
//  NetworkConstants.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import Foundation

struct API {
    private struct ProductionServer {
        static let URLbase = "https://api.football-data.org/v2"
    }
    
    struct Keys {
        
        struct headers {
            static let apiKey = "X-Auth-Token"
            static let ApiKey = "b771ff87465740ccabacd8f949203d07"
        }
        
        struct Home {
            static let competition = "\(API.ProductionServer.URLbase)/competitions"
            static let competitionDetails = "\(API.ProductionServer.URLbase)/competitions/"
            static let teams = "/teams"
            static let teamDetails = "\(API.ProductionServer.URLbase)/teams/"
        }
    }
}
