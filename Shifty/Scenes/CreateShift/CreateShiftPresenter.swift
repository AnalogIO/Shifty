//
//  CreateShiftPresenter.swift
//  CheckIn
//
//  Created by Frederik Christensen on 19/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities

protocol CreateShiftPresentationLogic {
    func createShiftStateDidChanged(to state: State<CreateShift.Response>)
}

class CreateShiftPresenter {
    weak var viewController: CreateShiftDisplayLogic?
}

extension CreateShiftPresenter: CreateShiftPresentationLogic {
    func createShiftStateDidChanged(to state: State<CreateShift.Response>) {
        switch state {
        case .loading:
            viewController?.createShiftStateDidChanged(to: .loading)
        case .loaded(_):
            let viewModel = CreateShift.ViewModel()
            viewController?.createShiftStateDidChanged(to: .loaded(viewModel))
        case .error(let error):
            viewController?.createShiftStateDidChanged(to: .error(error))
        case .unknown:
            viewController?.createShiftStateDidChanged(to: .unknown)
        }
    }
}
