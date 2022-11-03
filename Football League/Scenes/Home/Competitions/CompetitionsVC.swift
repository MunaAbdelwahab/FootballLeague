//
//  CompetitionsVC.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import UIKit
import RxSwift
import RxRealm
import RealmSwift

class CompetitionsVC: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var competitionCV: UICollectionView!
    @IBOutlet weak var competitionCVHeight: NSLayoutConstraint!
    
    //MARK:- Variables
    private var viewModel = CompetitionsViewModel()
    private var disposeBag = DisposeBag()
    var refreshControl: UIRefreshControl?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() {
            viewModel.getCompetitions()
            bindCompetitionsDataToCompetitionsCV()
            subscribeToCompetitionsSelection()
        } else {
            print("Internet Connection not Available!")
            read()
            CompetitionsSavedSelection()
        }

        registerCells()
        subscribeToAlert()
        addRefreshControl()
    }
    
    private func registerCells() {
        competitionCV.register(UINib(nibName: "CompetitionCell", bundle: nil), forCellWithReuseIdentifier: "CompetitionCell")
    }
    
    private func bindCompetitionsDataToCompetitionsCV() {
        viewModel.CompetitionsObserver.bind(to: competitionCV.rx.items(cellIdentifier: "CompetitionCell", cellType: CompetitionCell.self )) {[weak self] (row, competition, cell) in
            guard let self = self else {return}
            self.refreshControl?.endRefreshing()
            
            cell.setData(longN: competition.name, shortN: competition.code ?? "", gamesN: competition.numberOfGames ?? 0, teamsN: competition.numberOfTeams ?? 0)
            
            DispatchQueue.main.async {
                cell.layoutIfNeeded()
                self.competitionCV.layoutIfNeeded()
                self.competitionCVHeight.constant = self.competitionCV.contentSize.height
            }
            
            if let layout = self.competitionCV.collectionViewLayout as? UICollectionViewFlowLayout {
                let space: CGFloat = (layout.minimumInteritemSpacing ) + (layout.sectionInset.left) + (layout.sectionInset.right)
                let size : CGFloat = (self.competitionCV.frame.size.width - space) / 2.0
                layout.itemSize.width = size
            }
        }.disposed(by: disposeBag)
    }
    
    private func subscribeToCompetitionsSelection() {
        Observable.zip(competitionCV.rx.itemSelected, competitionCV.rx.modelSelected(Competition.self)).bind { [weak self] (indexPath, competition) in
            guard let self = self else {return}
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "CompetitionDetailsVC") as! CompetitionDetailsVC
            //VC.competitionId = "\(competition.id)"
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
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = #colorLiteral(red: 0.4258197546, green: 0.5040845275, blue: 0.4717505574, alpha: 1)
        refreshControl?.addTarget(self, action: #selector(refreshTableView(sender:)), for: .valueChanged)
        scrollView.addSubview(refreshControl!)
    }
    
    @objc func refreshTableView(sender: UIRefreshControl) {
        viewModel.getCompetitions()
    }
    
    private func read() {
        // Read from Realm
        print("Read from Realm")
        let data = realm.objects(CompetitionSave.self)
     
        Observable.collection(from: data).bind(to: competitionCV.rx.items(cellIdentifier: "CompetitionCell", cellType: CompetitionCell.self)) { (row, competition, cell) in
            cell.setData(longN: competition.name ?? "", shortN: competition.code ?? "", gamesN: competition.numberOfGames ?? 0, teamsN: competition.numberOfTeams ?? 0)
            
            DispatchQueue.main.async {
                cell.layoutIfNeeded()
                self.competitionCV.layoutIfNeeded()
                self.competitionCVHeight.constant = self.competitionCV.contentSize.height
            }
            
            if let layout = self.competitionCV.collectionViewLayout as? UICollectionViewFlowLayout {
                let space: CGFloat = (layout.minimumInteritemSpacing ) + (layout.sectionInset.left) + (layout.sectionInset.right)
                let size : CGFloat = (self.competitionCV.frame.size.width - space) / 2.0
                layout.itemSize.width = size
            }
        }.disposed(by: disposeBag)
    }
    
    private func CompetitionsSavedSelection() {
        Observable.zip(competitionCV.rx.itemSelected, competitionCV.rx.modelSelected(CompetitionSave.self)).bind { [weak self] (indexPath, competition) in
            guard let self = self else {return}
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "CompetitionDetailsVC") as! CompetitionDetailsVC
            //VC.competitionId = "\(competition.id)"
            self.navigationController?.pushViewController(VC, animated: true)
        }.disposed(by: disposeBag)
    }
}
