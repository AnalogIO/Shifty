//
//  DetailInteractor.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities
import ShiftPlanningAPI
import Client

protocol DetailBusinessLogic {
    func switchValueDidChange(to value: Bool, request: Detail.CheckInOut.Request)
    func fetchShift(request: Detail.FetchShift.Request)
    func didTapDeleteButton(request: Detail.DeleteShift.Request)
    func didUpdateEmployees(request: Detail.UpdateEmployees.Request)
}

protocol DetailDataStore {}

class DetailInteractor: DetailDataStore {
    var presenter: DetailPresentationLogic?
    
    fileprivate var checkInState: State<Detail.CheckInOut.Response> = .unknown {
        didSet {
            self.presenter?.checkInStateDidChanged(to: checkInState)
        }
    }
    
    fileprivate var fetchShiftState: State<Detail.FetchShift.Response> = .unknown {
        didSet {
            self.presenter?.fetchShiftStateDidChanged(to: fetchShiftState)
        }
    }
    
    fileprivate var deleteShiftState: State<Detail.DeleteShift.Response> = .unknown {
        didSet {
            self.presenter?.deleteShiftStateDidChanged(to: deleteShiftState)
        }
    }
    
    fileprivate var updateEmployeesState: State<Detail.UpdateEmployees.Response> = .unknown {
        didSet {
            self.presenter?.updateEmployeesStateDidChanged(to: updateEmployeesState)
        }
    }
}

extension DetailInteractor: DetailBusinessLogic {
    func didUpdateEmployees(request: Detail.UpdateEmployees.Request) {
        let api = ShiftPlanningAPI()
        updateEmployeesState = .loading
        let parameters: [String:Any] = [
            "employeeIds": request.employeeIds
        ]
        Shift.updateShift(shiftId: request.shiftId).response(using: api, method: .patch, parameters: parameters, headers: [:]) { [weak self](response: ResponseNoContent) in
            switch response {
            case .success:
                let response = Detail.UpdateEmployees.Response()
                self?.updateEmployeesState = .loaded(response)
            case .error(let error):
                self?.updateEmployeesState = .error(error)
            }
        }
    }
    func didTapDeleteButton(request: Detail.DeleteShift.Request) {
        let api = ShiftPlanningAPI()
        deleteShiftState = .loading
        Shift.deleteShift(shiftId: request.shiftId).response(using: api, method: .delete, parameters: [:], headers: [:]) { [weak self](response: ResponseNoContent) in
            switch response {
            case .success:
                let response = Detail.DeleteShift.Response()
                self?.deleteShiftState = .loaded(response)
            case .error(let error):
                self?.deleteShiftState = .error(error)
            }
        }
    }
    
    func switchValueDidChange(to checkedIn: Bool, request: Detail.CheckInOut.Request) {
        let api = ShiftPlanningAPI()
        checkInState = .loading
        if checkedIn {
            Employee.checkIn(shiftId: request.shiftId, employeeId: request.employeeId).response(using: api, method: .post, parameters: [:], headers: [:]) { [weak self](response: ResponseNoContent) in
                switch response {
                case .success:
                    let response = Detail.CheckInOut.Response()
                    self?.checkInState = .loaded(response)
                case .error(let error):
                    self?.checkInState = .error(error)
                }
            }
        } else {
            Employee.checkOut(shiftId: request.shiftId, employeeId: request.employeeId).response(using: api, method: .post, parameters: [:], headers: [:]) { [weak self](response: ResponseNoContent) in
                switch response {
                case .success:
                    let response = Detail.CheckInOut.Response()
                    self?.checkInState = .loaded(response)
                case .error(let error):
                    self?.checkInState = .error(error)
                }
            }
        }
    }
    
    func fetchShift(request: Detail.FetchShift.Request) {
        let api = ShiftPlanningAPI()
        fetchShiftState = .loading
        Shift.getShift(shiftId: request.shiftId).response(using: api, method: .get, parameters: [:], headers: [:]) { [weak self](response: Response<Shift>) in
            switch response {
            case .success(let shift):
                let response = Detail.FetchShift.Response(shift: shift)
                self?.fetchShiftState = .loaded(response)
            case .error(let error):
                self?.fetchShiftState = .error(error)
            }
        }
    }
}
