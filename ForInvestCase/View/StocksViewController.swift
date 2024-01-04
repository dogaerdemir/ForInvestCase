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
    
    let vm = StocksViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "StocksTableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
        
        vm.fetchStocksAndMenus { [weak self] result in
            guard let self else { return }
            
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    @IBAction func headerButtonTapped(_ sender: UIButton) {
        var actions: [UIAction] = []
        
        for menuOption in vm.getMenus() {
            let action = UIAction(title: menuOption.name ?? "Varsayılan İsim", handler: { _ in
                print("\(menuOption.name ?? "İsim Yok") seçildi")
            })
            actions.append(action)
        }

        let menu = UIMenu(title: "", children: actions)
        
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
    }
}

extension StocksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.getStocksCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as? StocksTableViewCell {
            cell.nameLabel.text = vm.getStocks()[indexPath.row].cod
            cell.clockLabel.text = vm.l[indexPath.row].clo
            cell.variableLabelOne.text = vm.l[indexPath.row].las
            cell.variableLabelTwo.text = vm.l[indexPath.row].pdd
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
