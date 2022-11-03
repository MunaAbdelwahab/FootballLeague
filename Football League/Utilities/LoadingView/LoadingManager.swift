//
//  LoadingManager.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import Foundation
import UIKit

class LoadingManager {
    static let shared = LoadingManager()
    
    private var containerView: UIView = {
        let view = UIView()
        view.frame = UIWindow(frame: UIScreen.main.bounds).frame
        view.center = UIWindow(frame: UIScreen.main.bounds).center
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return view
    }()
    
    private var progressView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        view.center = UIWindow(frame: UIScreen.main.bounds).center
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
        activityIndicator.color = #colorLiteral(red: 0.4258197546, green: 0.5040845275, blue: 0.4717505574, alpha: 1)
        return activityIndicator
    }()
    
    func showProgressView() {
        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)
        UIApplication.shared.keyWindow?.addSubview(containerView)
        activityIndicator.startAnimating()
    }
    
    func hideProgressView() {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }
}
