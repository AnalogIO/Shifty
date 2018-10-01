//
//  SelectEmployeesCell.swift
//  CheckIn
//
//  Created by Frederik Christensen on 21/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import UIKit

class SelectEmployeesCell: UITableViewCell {
    
    static let reuseIdentifier = "SelectEmployeesCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        configureViews()
        accessoryType = .disclosureIndicator
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
    
    private func configureViews() {
    }
}
