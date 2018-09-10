//
//  UIViewController.swift
//  ClipCard
//
//  Created by Frederik Dam Christensen on 15/02/2018.
//  Copyright © 2018 Frederik Dam Christensen. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorMessage(message: String, actionTitle: String, didPressAction: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: didPressAction)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showSuccessMessage(message: String, actionTitle: String, didPressAction: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: didPressAction)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showInputBox(message: String, title: String, actionTitle: String, placeholder1: String, placeholder2: String, type1: UIKeyboardType, type2: UIKeyboardType, didPressAction: @escaping ((String, String) -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = placeholder1
            textField.keyboardType = type1
        })
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = placeholder2
            textField.keyboardType = type2
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            guard let text1 = alertController.textFields?[0].text, let text2 = alertController.textFields?[1].text else { return }
            didPressAction(text1, text2)
        })
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
