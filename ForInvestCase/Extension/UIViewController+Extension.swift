//
//  UIViewController+Extension.swift
//  ForInvestCase
//
//  Created by Doğa Erdemir on 8.01.2024.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, actions: (buttonTitle: String, type: UIAlertAction.Style, action: ((UIAlertAction) -> Void)?)...) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for (title, style, handler) in actions {
            let action = UIAlertAction(title: title, style: style, handler: handler)
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true)
    }
}
