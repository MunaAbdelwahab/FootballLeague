//
//  UIViewExt.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import UIKit

extension UIView {
    func customShadowed(shadowRadius: CGFloat, height: CGFloat, shadowColor: CGColor) {
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: height)
        layer.masksToBounds = false
    }
}
