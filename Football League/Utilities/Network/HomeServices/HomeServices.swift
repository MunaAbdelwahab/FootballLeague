//
//  HomeServices.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import Foundation
import Alamofire
import RxSwift

class HomeServices {
    let apiClient = APIClient()
    
    func getCompetitions() -> Observable<Result<CompetitionResponse,AFError>> {
        let url = API.Keys.Home.competition
        let headers: HTTPHeaders = [API.Keys.headers.apiKey: API.Keys.headers.ApiKey]
        return apiClient.performRequest(url: url, method: .get, parameters: nil, headers: headers)
    }
    
    func getCompetitionDetails(competitionId: String) -> Observable<Result<CompetitionDetailsResponse,AFError>> {
        let url = "\(API.Keys.Home.competitionDetails)\(competitionId)"
        let headers: HTTPHeaders = [API.Keys.headers.apiKey: API.Keys.headers.ApiKey]
        return apiClient.performRequest(url: url, method: .get, headers: headers)
    }
    
    func getTeams(competitionId: String) -> Observable<Result<TeamsResponse,AFError>> {
        let url = "\(API.Keys.Home.competitionDetails)\(competitionId)\(API.Keys.Home.teams)"
        let headers: HTTPHeaders = [API.Keys.headers.apiKey: API.Keys.headers.ApiKey]
        return apiClient.performRequest(url: url, method: .get, parameters: nil, headers: headers)
    }
    
    func getTeamDetails(teamId: String) -> Observable<Result<TeamDetailsResponse,AFError>> {
        let url = "\(API.Keys.Home.teamDetails)\(teamId)"
        let headers: HTTPHeaders = [API.Keys.headers.apiKey: API.Keys.headers.ApiKey]
        return apiClient.performRequest(url: url, method: .get, parameters: nil, headers: headers)
    }
}
