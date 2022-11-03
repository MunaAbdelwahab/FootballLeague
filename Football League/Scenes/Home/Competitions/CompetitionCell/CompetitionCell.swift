//
//  CompetitionCell.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import UIKit

class CompetitionCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gamesNum: UILabel!
    @IBOutlet weak var teamsNum: UILabel!
    @IBOutlet weak var shortName: UILabel!
    @IBOutlet weak var longName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        backgroundColor = UIColor.clear
        
        backView.customShadowed(shadowRadius: 6.0, height: 3.0, shadowColor: #colorLiteral(red: 0.9275624156, green: 0.9373357892, blue: 0.9436758161, alpha: 1))
        backView.layer.cornerRadius = 10
    }

    func setData(longN: String, shortN: String, gamesN: Int, teamsN: Int) {
        longName.text = longN
        shortName.text = shortN
        gamesNum.text = "\(gamesN)"
        teamsNum.text = "\(teamsN)"
    }
}
