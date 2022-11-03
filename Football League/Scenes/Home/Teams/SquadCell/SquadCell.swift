//
//  SquadCell.swift
//  Football League
//
//  Created by Muna Abdelwahab on 03/10/2022.
//

import UIKit

class SquadCell: UICollectionViewCell {
    
    @IBOutlet weak var pNation: UILabel!
    @IBOutlet weak var pPosition: UILabel!
    @IBOutlet weak var pName: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        backgroundColor = UIColor.clear
        
        backView.customShadowed(shadowRadius: 6.0, height: 3.0, shadowColor: #colorLiteral(red: 0.9275624156, green: 0.9373357892, blue: 0.9436758161, alpha: 1))
        backView.layer.cornerRadius = 10
    }

    func setData(name: String, nation: String, position: String) {
        pName.text = name
        pPosition.text = position
        pNation.text = nation
    }
}
