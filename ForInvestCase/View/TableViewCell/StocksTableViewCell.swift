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
            variableLabelOne.text = model.stockDetail.getValue(for: keyForFirstButton)
        }
        if let keyForSecondButton = model.selectedKeyForSecondButton {
            variableLabelTwo.text = model.stockDetail.getValue(for: keyForSecondButton)
        }
        if let previousClo = model.previousClo, previousClo != model.stockDetail.clo {
            animateBackground()
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
