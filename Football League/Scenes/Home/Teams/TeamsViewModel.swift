//
//  TeamsViewModel.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class TeamsViewModel: AlertViewModel {
    
    let homeService = HomeServices()
    let disposeBag = DisposeBag()
    let realm = try! Realm()
    
    var idBehaviour: BehaviorRelay = BehaviorRelay<String>(value: "")
    
    private var TeamDetailsSubject: PublishSubject = PublishSubject<TeamDetailsResponse>()
    var TeamDetailsObserver: Observable<TeamDetailsResponse>{
        return TeamDetailsSubject
    }
    
    private var SquadSubject: PublishSubject = PublishSubject<[Squad]>()
    var SquadObserver: Observable<[Squad]>{
        return SquadSubject
    }
    
    private var alertSubject = PublishSubject<String>()
    var alertObservable: Observable<String>{
        return alertSubject
    }
    
    func getTeamDetails() {
        LoadingManager.shared.showProgressView()
        homeService.getTeamDetails(teamId: idBehaviour.value).subscribe(onNext: {[weak self] (result) in
            guard let self = self else {return}
            LoadingManager.shared.hideProgressView()
            switch result {
            case .success(let response):
                self.TeamDetailsSubject.onNext(response)
                self.SquadSubject.onNext(response.squad ?? [])
                self.saveCometitionsDetailsForOfflineUse(team: response)
            case .failure(let error):
                self.alertSubject.onNext(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
    
    func saveCometitionsDetailsForOfflineUse(team: TeamDetailsResponse) {
        deleteTeamDetails()
        try! self.realm.write {
            let team = self.getSavedCometitionsDetailsObject(team: team)
            self.realm.add(team)
        }
    }
    
    func getSavedCometitionsDetailsObject(team: TeamDetailsResponse) -> TeamDetailsSaved {
        let teams = TeamDetailsSaved()
        teams.name = team.name
        teams.image = team.crestURL
        teams.code = team.tla
        teams.colors = team.clubColors
        teams.email = team.email
        teams.phone = team.phone
        teams.address = team.address
        teams.web = team.website
        let savedArea = AreasSaved()
        savedArea.name = team.area.name
        teams.area = savedArea
        let squad = List<PlayerSaved>()
        for sq in team.squad! {
            let savedSquad = PlayerSaved()
            savedSquad.name = sq.name
            savedSquad.position = sq.position
            savedSquad.nationality = sq.nationality
            squad.append(savedSquad)
        }
        teams.player = squad
        return teams
    }
    
    private func deleteTeamDetails() {
        // Delete data
        print("Delete Data")
        if let tableToDelete = realm.objects(TeamDetailsSaved.self).first {
            try! realm.write {
                realm.delete(tableToDelete)
            }
        }
    }
}
