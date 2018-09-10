//
//  DetailPresenter.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities

protocol DetailPresentationLogic {
    func checkInStateDidChanged(to state: State<Detail.CheckInOut.Response>)
    func fetchShiftStateDidChanged(to state: State<Detail.FetchShift.Response>)
    func deleteShiftStateDidChanged(to state: State<Detail.DeleteShift.Response>)
    func updateEmployeesStateDidChanged(to state: State<Detail.UpdateEmployees.Response>)
}

class DetailPresenter {
    weak var viewController: DetailDisplayLogic?
    
    private func formatName(first: String, last: String) -> String {
        return "\(first) \(last)"
    }
}

extension DetailPresenter: DetailPresentationLogic {
    func updateEmployeesStateDidChanged(to state: State<Detail.UpdateEmployees.Response>) {
        switch state {
        case .loading:
            viewController?.updateEmployeesStateDidChanged(to: .loading)
        case .loaded(_):
            let viewModel = Detail.UpdateEmployees.ViewModel()
            viewController?.updateEmployeesStateDidChanged(to: .loaded(viewModel))
        case .error(let error):
            viewController?.updateEmployeesStateDidChanged(to: .error(error))
        case .unknown:
            viewController?.updateEmployeesStateDidChanged(to: .unknown)
        }
    }
    func deleteShiftStateDidChanged(to state: State<Detail.DeleteShift.Response>) {
        switch state {
        case .loading:
            viewController?.deleteShiftStateDidChanged(to: .loading)
        case .loaded(_):
            let viewModel = Detail.DeleteShift.ViewModel()
            viewController?.deleteShiftStateDidChanged(to: .loaded(viewModel))
        case .error(let error):
            viewController?.deleteShiftStateDidChanged(to: .error(error))
        case .unknown:
            viewController?.deleteShiftStateDidChanged(to: .unknown)
        }
    }
    func checkInStateDidChanged(to state: State<Detail.CheckInOut.Response>) {
        switch state {
        case .loading:
            viewController?.checkInStateDidChanged(to: .loading)
        case .loaded(_):
            let viewModel = Detail.CheckInOut.ViewModel()
            viewController?.checkInStateDidChanged(to: .loaded(viewModel))
        case .error(let error):
            viewController?.checkInStateDidChanged(to: .error(error))
        case .unknown:
            viewController?.checkInStateDidChanged(to: .unknown)
        }
    }
    func fetchShiftStateDidChanged(to state: State<Detail.FetchShift.Response>) {
        switch state {
        case .loading:
            viewController?.fetchShiftStateDidChanged(to: .loading)
        case .loaded(let response):
            let employeeCellConfigs:[CheckInCellConfig] = response.shift.employees.map {
                let employeeId = $0.id
                return CheckInCellConfig(
                    id: employeeId,
                    name: formatName(first: $0.firstName, last: $0.lastName),
                    checkedIn: !response.shift.checkIns.filter { $0.employee.id == employeeId }.isEmpty
                )
            }
            let isDelible = response.shift.scheduleId == nil ? true : false
            let employeeIds = response.shift.employees.map { $0.id }
            let viewModel = Detail.FetchShift.ViewModel(shiftId: response.shift.id, cellConfigs: employeeCellConfigs, employeeIds: employeeIds, isDelible: isDelible)
            viewController?.fetchShiftStateDidChanged(to: .loaded(viewModel))
        case .error(let error):
            viewController?.fetchShiftStateDidChanged(to: .error(error))
        case .unknown:
            viewController?.fetchShiftStateDidChanged(to: .unknown)
        }
    }
}
