//
//  DatePickerTableViewCell.swift
//  CheckIn
//
//  Created by Frederik Christensen on 19/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {

    static let reuseIdentifier = "DatePickerCell"
    private let labelHeight: CGFloat = 44
    private let datePickerHeight: CGFloat = 200
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "da_DK_POSIX")
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let detail: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.setDate(Date(), animated: false)
        datePicker.minuteInterval = 15
        return datePicker
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        detail.text = dateFormatter.string(from: datePicker.date)
        selectionStyle = .none
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
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.cell).isActive = true
        title.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(detail)
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.topAnchor.constraint(equalTo: topAnchor).isActive = true
        detail.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margin.cell).isActive = true
        detail.leadingAnchor.constraint(equalTo: title.trailingAnchor).isActive = true
        detail.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: datePickerHeight).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        detail.text = dateFormatter.string(from: sender.date)
    }
    
    public func setTitle(_ value: String) {
        title.text = value
    }
    
    public func getDate() -> Date {
        return datePicker.date
    }
}
