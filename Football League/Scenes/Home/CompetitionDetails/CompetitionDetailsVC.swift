//
//  CompetitionDetailsVC.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import UIKit
import RxSwift
import RealmSwift
import RxRealm

class CompetitionDetailsVC: UIViewController {
    
    @IBOutlet weak var teamsCV: UICollectionView!
    @IBOutlet weak var seasonsCV: UICollectionView!
    @IBOutlet weak var plan: UILabel!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var compS: UILabel!
    @IBOutlet weak var compL: UILabel!
    @IBOutlet weak var compIV: UIImageView!
    
    //MARK:- Variables
    private var viewModel = CompetitionDetailsViewModel()
    private var disposeBag = DisposeBag()
    let competitionId = "2000"
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.idBehaviour.accept(competitionId)
        
        if Reachability.isConnectedToNetwork() {
            viewModel.getCompetitionDetails()
            viewModel.getTeams()
            bindCompitionDetailsData()
            bindSeasonsDataToSeasonsCV()
            bindTeamsDataToTeamsCV()
            subscribeToTeamsSelection()
        } else {
            print("Internet Connection not Available!")
            readTeams()
            readCompetitionDetails()
            TeamsSavedSelection()
        }
        
        registerCells()
        subscribeToAlert()
    }
    
    private func registerCells() {
        seasonsCV.register(UINib(nibName: "SeasonCell", bundle: nil), forCellWithReuseIdentifier: "SeasonCell")
        teamsCV.register(UINib(nibName: "TeamCell", bundle: nil), forCellWithReuseIdentifier: "TeamCell")
    }
    
    private func bindCompitionDetailsData() {
        viewModel.CompetitionDetailsObserver.subscribe(onNext: {[weak self] competition in
            guard let self = self else {return}
            self.compIV.sd_setImage(with: URL(string: competition.emblemURL ?? ""))
            self.compL.text = competition.name
            self.compS.text = competition.code
            self.area.text = competition.area?.name
            self.plan.text = competition.plan
        }).disposed(by: disposeBag)
    }
    
    private func bindSeasonsDataToSeasonsCV() {
        viewModel.SeasonsObserver.bind(to: seasonsCV.rx.items(cellIdentifier: "SeasonCell", cellType: SeasonCell.self )) {[weak self] (row, season, cell) in
            guard let self = self else {return}
            cell.setData(image: season.winner?.crestURL ?? "", n: season.winner?.name ?? "", start: season.startDate, end: season.endDate, Tla: season.winner?.tla ?? "")
        }.disposed(by: disposeBag)
    }
    
    private func bindTeamsDataToTeamsCV() {
        viewModel.TeamsObserver.bind(to: teamsCV.rx.items(cellIdentifier: "TeamCell", cellType: TeamCell.self )) {[weak self] (row, team, cell) in
            guard let self = self else {return}
            cell.setData(image: team.crestURL, short: team.shortName ?? "", long: team.name)
        }.disposed(by: disposeBag)
    }
    
    private func subscribeToTeamsSelection() {
        Observable.zip(teamsCV.rx.itemSelected, teamsCV.rx.modelSelected(Team.self)).bind { [weak self] (indexPath, team) in
            guard let self = self else {return}
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "TeamsVC") as! TeamsVC
            VC.teamId = "\(team.id)"
            self.navigationController?.pushViewController(VC, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func subscribeToAlert() {
        viewModel.alertObservable.subscribe( { [weak self] (alert) in
            guard let self = self else {return}
            if alert.element ?? "" != "" {
                self.showAlert(with: .reguler, msg: alert.element!)
            }
        }).disposed(by: disposeBag)
    }
    
    private func readCompetitionDetails() {
        // Read from Realm
        print("Read from Realm")
        let data = realm.objects(CompetitionDetailsSaved.self)
        
        self.compIV.sd_setImage(with: URL(string: data.first?.image ?? ""))
        self.compL.text = data.first?.name
        self.compS.text = data.first?.code
        self.area.text = data.first?.area?.name
        self.plan.text = data.first?.plan
        
        let data2 = realm.objects(SeasonSave.self)
        Observable.collection(from: data2).bind(to: seasonsCV.rx.items(cellIdentifier: "SeasonCell", cellType: SeasonCell.self)) { (row, season, cell) in
            cell.setData(image: season.winner?.image ?? "", n: season.winner?.name ?? "", start: season.start ?? "", end: season.end ?? "", Tla: season.winner?.tla ?? "")
        }.disposed(by: disposeBag)
    }
    
    private func readTeams() {
        // Read from Realm
        print("Read from Realm")
        let data = realm.objects(TeamsSave.self)
     
        Observable.collection(from: data).bind(to: teamsCV.rx.items(cellIdentifier: "TeamCell", cellType: TeamCell.self)) { (row, team, cell) in
            cell.setData(image: team.image ?? "", short: team.shortName ?? "", long: team.longName ?? "")
            
        }.disposed(by: disposeBag)
    }
    
    private func TeamsSavedSelection() {
        Observable.zip(teamsCV.rx.itemSelected, teamsCV.rx.modelSelected(TeamsSave.self)).bind { [weak self] (indexPath, team) in
            guard let self = self else {return}
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "TeamsVC") as! TeamsVC
            VC.teamId = "\(team.id ?? 0)"
            self.navigationController?.pushViewController(VC, animated: true)
        }.disposed(by: disposeBag)
    }
}
