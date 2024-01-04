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
    
    /*func configureCell(stock: StocksModel) {
        indicatorImage.image = UIImage(named: "green_up")
        
    }*/
    
}
