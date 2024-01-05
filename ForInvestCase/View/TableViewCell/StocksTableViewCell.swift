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
        variableLabelOne.text = model.stockDetail.las
        variableLabelTwo.text = model.stockDetail.pdd
        
        if let previousClo = model.previousClo, previousClo != model.stockDetail.clo {
            animateBackground()
        }
        clockLabel.text = model.stockDetail.clo
    }
    
    private func animateBackground() {
        self.layer.removeAllAnimations()
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.backgroundColor = .clear
        })
    }
}
