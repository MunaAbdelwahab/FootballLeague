//
//  TeamsVC.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import UIKit
import RxSwift
import RxRealm
import RealmSwift

class TeamsVC: UIViewController {
    
    @IBOutlet weak var memberView: UIView!
    @IBOutlet weak var squadCV: UICollectionView!
    @IBOutlet weak var colors: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var web: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageIV: UIImageView!
    
    //MARK:- Variables
    private var viewModel = TeamsViewModel()
    private var disposeBag = DisposeBag()
    var teamId: String?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.idBehaviour.accept(teamId ?? "")
        
        if Reachability.isConnectedToNetwork() {
            viewModel.getTeamDetails()
            bindTeamDetailsData()
        } else {
            print("Internet Connection not Available!")
            readTeams()
        }
        
        registerCells()
        subscribeToAlert()
    }
    
    private func registerCells() {
        squadCV.register(UINib(nibName: "SquadCell", bundle: nil), forCellWithReuseIdentifier: "SquadCell")
    }
    
    private func bindTeamDetailsData() {
        viewModel.TeamDetailsObserver.subscribe(onNext: {[weak self] team in
            guard let self = self else {return}
            self.imageIV.sd_setImage(with: URL(string: team.crestURL))
            self.name.text = team.name
            self.code.text = team.tla
            self.area.text =  team.area.name
            self.phone.text =  team.phone
            self.address.text =  team.address
            self.web.text =  team.website
            self.email.text =  team.email
            self.colors.text =  team.clubColors
            if team.squad?.isEmpty != nil {
                self.memberView.isHidden = true
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindSquadDataToSquadCV() {
        viewModel.SquadObserver.bind(to: squadCV.rx.items(cellIdentifier: "SquadCell", cellType: SquadCell.self )) {[weak self] (row, squad, cell) in
            guard let self = self else {return}
            cell.setData(name: squad.name, nation: squad.nationality, position: squad.position)
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
    
    private func readTeams() {
        // Read from Realm
        print("Read from Realm")
        let data = realm.objects(TeamDetailsSaved.self)
     
        self.imageIV.sd_setImage(with: URL(string: data.first?.image ?? ""))
        self.name.text = data.first?.name
        self.code.text = data.first?.code
        self.area.text =  data.first?.area?.name
        self.phone.text =  data.first?.phone
        self.address.text =  data.first?.address
        self.web.text =  data.first?.web
        self.email.text =  data.first?.email
        self.colors.text =  data.first?.colors
        
        let data2 = realm.objects(PlayerSaved.self)
        Observable.collection(from: data2).bind(to: squadCV.rx.items(cellIdentifier: "SquadCell", cellType: SquadCell.self)) { (row, squad, cell) in
            cell.setData(name: squad.name ?? "", nation: squad.nationality ?? "", position: squad.position ?? "")
            
        }.disposed(by: disposeBag)
    }
}
