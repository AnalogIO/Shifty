//
//  MasterPresenter.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright (c) 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Freddy
import Entities

protocol MasterPresentationLogic {
    func fetchShiftsStateDidChanged(to state: State<Master.Fetch.Response>)
}

class MasterPresenter {
    weak var viewController: MasterDisplayLogic?
    
    private func formatInterval(start: String, end: String) -> String {
        let dateFormatter = DateFormatter()
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "da_DK_POSIX")
        dateFormatter.dateFormat = dateFormat
        let start = dateFormatter.date(from: start)
        let end = dateFormatter.date(from: end)
        guard let safeStart = start, let safeEnd = end else {
            print("The date does not conform to: \(dateFormat)")
            return ""
        }
        return "\(safeStart.hour()):\(safeStart.minute()) - \(safeEnd.hour()):\(safeEnd.minute())"
    }
}

extension MasterPresenter: MasterPresentationLogic {
    func fetchShiftsStateDidChanged(to state: State<Master.Fetch.Response>) {
        switch state {
        case .loading:
            viewController?.fetchShiftsStateDidChanged(to: .loading)
        case .loaded(let response):
            let shiftCellConfigs = response.shifts.shifts.map {
                ShiftCellConfig(interval: formatInterval(start: $0.start, end: $0.end))
            }
            let shiftIds = response.shifts.shifts.map { return $0.id }
            let viewModel = Master.Fetch.ViewModel(shiftIds: shiftIds, shiftCellConfigs: shiftCellConfigs)
            viewController?.fetchShiftsStateDidChanged(to: .loaded(viewModel))
        case .error(let error):
            viewController?.fetchShiftsStateDidChanged(to: .error(error))
        case .unknown:
            viewController?.fetchShiftsStateDidChanged(to: .unknown)
        }
    }
}
