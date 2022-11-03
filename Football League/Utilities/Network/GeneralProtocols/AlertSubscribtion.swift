//
//  AlertSubscribtion.swift
//  Football League
//
//  Created by Muna Abdelwahab on 02/10/2022.
//

import Foundation
import RxSwift

protocol AlertSubscribtion {
    func subscribeToAlert(viewModel: AlertViewModel, disposeBag: DisposeBag)
}

protocol AlertViewModel {
    var alertObservable: Observable<String> { get }
}
