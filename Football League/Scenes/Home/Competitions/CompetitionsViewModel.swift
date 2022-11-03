//
//  CompetitionsViewModel.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class CompetitionsViewModel: AlertViewModel {
    
    let homeService = HomeServices()
    let disposeBag = DisposeBag()
    let realm = try! Realm()
     
    private var CompetitionsSubject: PublishSubject = PublishSubject<[Competition]>()
    var CompetitionsObserver: Observable<[Competition]>{
        return CompetitionsSubject
    }
    
    private var alertSubject = PublishSubject<String>()
    var alertObservable: Observable<String>{
        return alertSubject
    }
    
    func getCompetitions() {
        LoadingManager.shared.showProgressView()
        homeService.getCompetitions().subscribe(onNext: {[weak self] (result) in
            guard let self = self else {return}
            LoadingManager.shared.hideProgressView()
            switch result {
            case .success(let response):
                self.CompetitionsSubject.onNext(response.competitions)
                self.saveCometitionsForOfflineUse(cometition: response)
            case .failure(let error):
                self.alertSubject.onNext(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
    
    func saveCometitionsForOfflineUse(cometition: CompetitionResponse) {
        delete()
        try! self.realm.write {
            let cometition = self.getSavedCometitionsObject(competition: cometition)
            self.realm.add(cometition)
        }
    }
    
    func getSavedCometitionsObject(competition: CompetitionResponse) -> CompetitionsSaved {
        let competitions = CompetitionsSaved()
        let comp = List<CompetitionSave>()
        for comps in competition.competitions {
            let savedCompetition = CompetitionSave()
            savedCompetition.name = comps.name
            savedCompetition.numberOfGames = comps.numberOfGames
            savedCompetition.numberOfTeams = comps.numberOfTeams
            savedCompetition.code = comps.code
            savedCompetition.id = comps.id
            comp.append(savedCompetition)
        }
        competitions.competitions = comp
        return competitions
    }
    
    private func delete() {
        // Delete data
        print("Delete Data")
        if let tableToDelete = realm.objects(CompetitionSave.self).first {
            try! realm.write {
                realm.delete(tableToDelete)
            }
        }
    }
}
