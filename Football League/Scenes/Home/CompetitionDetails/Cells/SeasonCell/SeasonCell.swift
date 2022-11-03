//
//  SeasonCell.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import UIKit
import SDWebImage

class SeasonCell: UICollectionViewCell {

    @IBOutlet weak var winnerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tla: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var endD: UILabel!
    @IBOutlet weak var startD: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageIV.makeRounded()
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        backgroundColor = UIColor.clear
        
        backView.customShadowed(shadowRadius: 6.0, height: 3.0, shadowColor: #colorLiteral(red: 0.9275624156, green: 0.9373357892, blue: 0.9436758161, alpha: 1))
        backView.layer.cornerRadius = 10
    }

    func setData(image: String, n: String, start: String, end: String, Tla: String) {
        name.text = n
        startD.text = start
        endD.text = end
        tla.text = Tla
        
        let formattedString = image.replacingOccurrences(of: " ", with: "%20")
        imageIV.sd_setImage(with: URL(string: formattedString)) {[weak self] img, _, _, _ in
            guard let self = self else {return}
            self.activityIndicator.isHidden = true
            if let _ = img {
            } else {
                self.imageIV.image = UIImage(named: "")
            }
        }
        
        if n == "" {
            winnerView.isHidden = true
        }
    }
}
