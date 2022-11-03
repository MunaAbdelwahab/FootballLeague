//
//  ViewController.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import UIKit

class SplashScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setSplashImg()
    }
    
    func setSplashImg() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {[weak self] (_) in
            guard let self = self else {return}
            self.goToHomeScreen()
        }
    }
    
    private func goToHomeScreen(){
        SetStoryBoard.controller(controllerIdentifier: "App", story: "App") { (controller) in
            if #available(iOS 13.0, *) {
                let Delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                Delegate.window?.rootViewController = controller
            }else{
                let Delegate = UIApplication.shared.delegate as! AppDelegate
                Delegate.window?.rootViewController = controller
            }
        }
    }
}
