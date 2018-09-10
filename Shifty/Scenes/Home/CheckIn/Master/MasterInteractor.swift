//
//  MasterInteractor.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities
import ShiftPlanningAPI
import Client

protocol MasterBusinessLogic {
    func fetchShifts()
}

protocol MasterDataStore {}

class MasterInteractor: MasterDataStore {
    var presenter: MasterPresentationLogic?
    
    fileprivate var fetchShiftsState: State<Master.Fetch.Response> = .unknown {
        didSet {
            self.presenter?.fetchShiftsStateDidChanged(to: fetchShiftsState)
        }
    }
}

extension MasterInteractor: MasterBusinessLogic {
    func fetchShifts() {
        let api = ShiftPlanningAPI()
        fetchShiftsState = .loading
        Shifts.getShifts().response(using: api, method: .get, parameters: [:], headers: [:]) { [weak self](response: Response<Shifts>) in
            switch response {
            case .success(let shifts):
                let response = Master.Fetch.Response(shifts: shifts)
                self?.fetchShiftsState = .loaded(response)
            case .error(let error):
                self?.fetchShiftsState = .error(error)
            }
        }
    }
}
