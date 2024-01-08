//
//  UIView+Extension.swift
//  ForInvestCase
//
//  Created by Doğa Erdemir on 7.01.2024.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderColor:UIColor? {
        get {
            if let color = layer.borderColor { return UIColor(cgColor: color) }
            else { return nil }
        }
        set { layer.borderColor = newValue!.cgColor }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
}
