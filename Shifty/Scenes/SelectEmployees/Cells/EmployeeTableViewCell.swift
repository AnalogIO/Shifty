//
//  EmployeeTableViewCell.swift
//  CheckIn
//
//  Created by Frederik Christensen on 19/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import UIKit
import Entities

class EmployeeTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "EmployeeCell"
    var isChecked: Bool = false {
        didSet {
            accessoryType = isChecked ? .checkmark : .none
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(employee: Employee) {
        textLabel?.text = "\(employee.firstName) \(employee.lastName)"
    }
}
