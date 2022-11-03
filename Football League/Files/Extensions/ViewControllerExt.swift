//
//  ViewControllerExt.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import UIKit

enum AlertStyle{
    case login, reguler, withScope, withButton
}

extension UIViewController{
    
    func popBack(_ nb: Int) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < nb else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                return
            }
        }
    }
    
    func showAlert(with Style: AlertStyle, msg: String,  compilition: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            
            switch Style {
            case .login:
                let ok = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.dismiss(animated: true, completion: nil)
                }
                let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(ok)
                alert.addAction(Cancel)
                break
            case .reguler, .withScope:
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (_) in
                    alert.dismiss(animated: true) {
                        compilition?()
                    }
                }
                break
            case .withButton:
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                break
            }
            self.present(alert, animated: true)
        }
    }
}
