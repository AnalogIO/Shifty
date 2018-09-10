//
//  Date+Units.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation

extension Date {
    
    private func components() -> DateComponents  {
        return Calendar.current.dateComponents(in: TimeZone(identifier: "Europe/Copenhagen")!, from: self)
    }
    
    func hour () -> String {
        if self.components().hour!.description.count == 1 {
            return "0\(self.components().hour!)"
        } else {
            return "\(self.components().hour!)"
        }
    }
    
    func minute () -> String {
        if self.components().minute!.description.count == 1 {
            return "0\(self.components().minute!)"
        } else {
            return "\(self.components().minute!)"
        }
    }
}
