//
//  GeneralClasses.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import UIKit

class SetStoryBoard {
    static func controller(controllerIdentifier: String,story:String, compilition: (UIViewController)->Void) {
        let Story = UIStoryboard(name: story, bundle: Bundle.main)
        let controller = Story.instantiateViewController(withIdentifier: controllerIdentifier)
        compilition(controller)
    }
}
