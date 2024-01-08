//
//  TableViewCell.swift
//  ForInvestCase
//
//  Created by Doğa Erdemir on 3.01.2024.
//

import UIKit

class StocksTableViewCell: UITableViewCell {

    @IBOutlet weak var indicatorImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var variableLabelOne: UILabel!
    @IBOutlet weak var variableLabelTwo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(with model: StockCellModel) {
        nameLabel.text = model.stocks?.cod
        clockLabel.text = model.stockDetail?.clo
        indicatorImage.alpha = 1
        
        configureLabel(variableLabelOne, withKey: model.selectedKeyForFirstButton, from: model)
        configureLabel(variableLabelTwo, withKey: model.selectedKeyForSecondButton, from: model)
        
        checkForVisualChanges(with: model)
    }
    
    private func configureLabel(_ label: UILabel, withKey key: String?, from model: StockCellModel) {
        if let key = key {
            let text = model.stockDetail?.getValue(for: key) ?? "N/A"
            label.text = text
            
            if key == "ddi" || key == "pdd" {
                label.textColor = Double(text.replacingOccurrences(of: ",", with: ".")) ?? 0 > 0 ? .systemGreen : .systemRed
            } else {
                label.textColor = .appPrimaryLabel
            }
        }
    }
    
    private func checkForVisualChanges(with model: StockCellModel) {
        if let previousClo = model.previousClo, previousClo != model.stockDetail?.clo {
            animateBackground()
        }
        if let previousLas = model.previousLas,
           let currentLas = Int(model.stockDetail?.las?.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "") ?? "0"),
           let previousLasDouble = Int(previousLas.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")) {
            
            if currentLas > previousLasDouble {
                indicatorImage.image = UIImage(named: "green_up")
            } else if currentLas < previousLasDouble {
                indicatorImage.image = UIImage(named: "red_down")
            } else {
                indicatorImage.alpha = 0
            }
        }
    }
    
    private func animateBackground() {
        self.layer.removeAllAnimations()
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.backgroundColor = .clear
        })
    }
}
