//
//  EmployeeTableViewCell.swift
//  CheckIn
//
//  Created by Frederik Christensen on 19/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import UIKit

class CheckInTableViewCell: UITableViewCell {

    static let reuseIdentifier = "CheckInCell"
    
    let switchButton: UISwitch = {
        let switchButton = UISwitch()
        return switchButton
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(cellConfig: CheckInCellConfig) {
        textLabel?.text = cellConfig.name
        switchButton.isOn = cellConfig.checkedIn
        switchButton.tag = cellConfig.id
    }
    
    private func configureViews() {
        addSubview(switchButton)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Margin.cell).isActive = true
        switchButton.topAnchor.constraint(equalTo: self.topAnchor, constant: Margin.cell).isActive = true
        switchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Margin.cell).isActive = true
    }
}

public struct CheckInCellConfig {
    let id: Int
    let name: String
    let checkedIn: Bool
    
    init(id: Int, name: String, checkedIn: Bool) {
        self.id = id
        self.name = name
        self.checkedIn = checkedIn
    }
}
