//
//  CreateShiftInteractor.swift
//  CheckIn
//
//  Created by Frederik Christensen on 19/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities
import ShiftPlanningAPI
import Client

protocol CreateShiftBusinessLogic {
    func createShift(request: CreateShift.Request)
}

protocol CreateShiftDataStore {}

class CreateShiftInteractor: CreateShiftDataStore {
    var presenter: CreateShiftPresentationLogic?
    
    fileprivate var createShiftState: State<CreateShift.Response> = .unknown {
        didSet {
            self.presenter?.createShiftStateDidChanged(to: createShiftState)
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        let dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateFormatter.locale = Locale(identifier: "da_DK_POSIX")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter
    }()
}

extension CreateShiftInteractor: CreateShiftBusinessLogic {
    func createShift(request: CreateShift.Request) {
        let api = ShiftPlanningAPI()
        createShiftState = .loading
        let parameters: [String:Any] = [
            "employeeIds": request.employeeIds,
            "start": dateFormatter.string(from: request.start),
            "end": dateFormatter.string(from: request.end)
        ]
        Shifts.createShift().response(using: api, method: .post, parameters: parameters, headers: [:]) { [weak self](response: Response<Shift>) in
            switch response {
            case .success(let shift):
                let response = CreateShift.Response(shift: shift)
                self?.createShiftState = .loaded(response)
            case .error(let error):
                self?.createShiftState = .error(error)
            }
        }
    }
}
