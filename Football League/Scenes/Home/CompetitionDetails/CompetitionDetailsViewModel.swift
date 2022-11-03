//
//  CompetitionDetailsViewModel.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class CompetitionDetailsViewModel: AlertViewModel {
    
    let homeService = HomeServices()
    let disposeBag = DisposeBag()
    let realm = try! Realm()
    
    var idBehaviour: BehaviorRelay = BehaviorRelay<String>(value: "")
    
    private var CompetitionDetailsSubject: PublishSubject = PublishSubject<CompetitionDetailsResponse>()
    var CompetitionDetailsObserver: Observable<CompetitionDetailsResponse>{
        return CompetitionDetailsSubject
    }
    
    private var SeasonsSubject: PublishSubject = PublishSubject<[Season]>()
    var SeasonsObserver: Observable<[Season]>{
        return SeasonsSubject
    }
    
    private var TeamsSubject: PublishSubject = PublishSubject<[Team]>()
    var TeamsObserver: Observable<[Team]>{
        return TeamsSubject
    }
    
    private var alertSubject = PublishSubject<String>()
    var alertObservable: Observable<String>{
        return alertSubject
    }
    
    func getCompetitionDetails() {
        LoadingManager.shared.showProgressView()
        homeService.getCompetitionDetails(competitionId: idBehaviour.value).subscribe(onNext: {[weak self] (result) in
            guard let self = self else {return}
            LoadingManager.shared.hideProgressView()
            switch result {
            case .success(let response):
                if response.name != "" {
                    self.CompetitionDetailsSubject.onNext(response)
                    self.SeasonsSubject.onNext(response.seasons ?? [])
                    self.saveCometitionsDetailsForOfflineUse(cometition: response)
                } else {
                    self.alertSubject.onNext("Not Found Data")
                }
            case .failure(let error):
                self.alertSubject.onNext(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
    
    func getTeams() {
        LoadingManager.shared.showProgressView()
        homeService.getTeams(competitionId: idBehaviour.value).subscribe(onNext: {[weak self] (result) in
            guard let self = self else {return}
            LoadingManager.shared.hideProgressView()
            switch result {
            case .success(let response):
                self.TeamsSubject.onNext(response.teams ?? [])
                self.saveTeamsForOfflineUse(team: response)
            case .failure(let error):
                self.alertSubject.onNext(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
    
    func saveCometitionsDetailsForOfflineUse(cometition: CompetitionDetailsResponse) {
        deleteCompetionDetails()
        try! self.realm.write {
            let cometition = self.getSavedCometitionsDetailsObject(competition: cometition)
            self.realm.add(cometition)
        }
    }
    
    func getSavedCometitionsDetailsObject(competition: CompetitionDetailsResponse) -> CompetitionDetailsSaved {
        let competitions = CompetitionDetailsSaved()
        competitions.name = competition.name
        competitions.image = competition.emblemURL
        competitions.code = competition.code
        competitions.plan = competition.plan
        let savedArea = AreaSaved()
        savedArea.name = competition.area?.name
        competitions.area = savedArea
        let seson = List<SeasonSave>()
        for seas in competition.seasons! {
            let savedSeason = SeasonSave()
            savedSeason.start = seas.startDate
            savedSeason.end = seas.endDate
            let savedWinner = WinnerSaved()
            savedWinner.name = seas.winner?.name
            savedWinner.tla = seas.winner?.tla
            savedWinner.image = seas.winner?.crestURL
            savedSeason.winner = savedWinner
            seson.append(savedSeason)
        }
        competitions.seasons = seson
        return competitions
    }
    
    private func deleteCompetionDetails() {
        // Delete data
        print("Delete Data")
        if let tableToDelete = realm.objects(CompetitionSave.self).first {
            try! realm.write {
                realm.delete(tableToDelete)
            }
        }
    }
    
    func saveTeamsForOfflineUse(team: TeamsResponse) {
        deleteTeams()
        try! self.realm.write {
            let team = self.getSavedTeamsObject(team: team)
            self.realm.add(team)
        }
    }
    
    func getSavedTeamsObject(team: TeamsResponse) -> TeamSaved {
        let teams = TeamSaved()
        let tem = List<TeamsSave>()
        for tems in team.teams! {
            let savedTeam = TeamsSave()
            savedTeam.longName = tems.name
            savedTeam.image = tems.crestURL
            savedTeam.shortName = tems.shortName
            savedTeam.id = tems.id
            tem.append(savedTeam)
        }
        teams.teams = tem
        return teams
    }
    
    private func deleteTeams() {
        // Delete data
        print("Delete Data")
        if let tableToDelete = realm.objects(TeamsSave.self).first {
            try! realm.write {
                realm.delete(tableToDelete)
            }
        }
    }
}
