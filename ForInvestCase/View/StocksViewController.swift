//
//  ViewController.swift
//  ForInvestCase
//
//  Created by Doğa Erdemir on 3.01.2024.
//

import UIKit

class StocksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableViewHeaderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "StocksTableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
    }

    @IBAction func headerButtonTapped(_ sender: UIButton) {
        let action1 = UIAction(title: "Seçenek 1", handler: { _ in
            print("Seçenek 1 seçildi")
        })
        let action2 = UIAction(title: "Seçenek 2", handler: { _ in
            print("Seçenek 2 seçildi")
        })
        
        let menu = UIMenu(title: "", children: [action1, action2])
        
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
    }
}

extension StocksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as? StocksTableViewCell {
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableViewHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}
