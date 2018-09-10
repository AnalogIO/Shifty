//
//  ShiftTableViewCell.swift
//  CheckIn
//
//  Created by Frederik Christensen on 19/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import UIKit

class ShiftTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ShiftCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(cellConfig: ShiftCellConfig) {
        textLabel?.text = cellConfig.interval
        accessoryType = .disclosureIndicator
    }
}

struct ShiftCellConfig {
    let interval: String
    
    init(interval: String) {
        self.interval = interval
    }
}
