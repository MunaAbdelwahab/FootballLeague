//
//  UIImageViewExt.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import UIKit

extension UIImageView {
    
    func makeRounded() {
        layer.masksToBounds = false
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
