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
        nameLabel.text = model.stocks.cod
        clockLabel.text = model.stockDetail.clo
        
        if let keyForFirstButton = model.selectedKeyForFirstButton {
            let text = model.stockDetail.getValue(for: keyForFirstButton)
            if keyForFirstButton == "ddi" || keyForFirstButton == "pdd" {
                if Double(text?.replacingOccurrences(of: ",", with: ".") ?? "0") ?? 0 > 0 {
                    variableLabelOne.textColor = .systemGreen
                } else {
                    variableLabelOne.textColor = .red
                }
            } else {
                variableLabelOne.textColor = .white
            }
            variableLabelOne.text = text
        }
        if let keyForSecondButton = model.selectedKeyForSecondButton {
            let text = model.stockDetail.getValue(for: keyForSecondButton)
            if keyForSecondButton == "ddi" || keyForSecondButton == "pdd" {
                if Double(text?.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: "%", with:"") ?? "0") ?? 0 > 0 {
                    variableLabelTwo.textColor = .systemGreen
                } else {
                    variableLabelTwo.textColor = .red
                }
            } else {
                variableLabelTwo.textColor = .white
            }
            variableLabelTwo.text = text
        }
        if let previousClo = model.previousClo, previousClo != model.stockDetail.clo {
            animateBackground()
        }
        
        if let previousLas = model.previousLasValue, let currentLas = Double(model.stockDetail.las?.replacingOccurrences(of: ",", with: ".") ?? "0"), let previousLasDouble = Double(previousLas.replacingOccurrences(of: ",", with: ".")) {
            indicatorImage.image = currentLas > previousLasDouble ? UIImage(named: "green_up") : UIImage(named: "red_down")
        }
    }
    
    private func animateBackground() {
        self.layer.removeAllAnimations()
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.backgroundColor = .clear
        })
    }
}
