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
        vm.delegate = self
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
    
    func createMenu(with button: UIButton) -> UIMenu {
        var actions: [UIAction] = []
        
        for menuOption in vm.getMenus() {
            let action = UIAction(title: menuOption.name ?? "N/A", handler: { [weak self] _ in
                if button.tag == 1 {
                    self?.vm.selectedKeyForFirstButton = menuOption.key
                } else if button.tag == 2 {
                    self?.vm.selectedKeyForSecondButton = menuOption.key
                }
                button.setTitle(menuOption.name, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                self?.tableView.reloadData()
            })
            actions.append(action)
        }
        
        let menu = UIMenu(title: "", children: actions)
        return menu
    }
    
    @IBAction func headerButtonTapped(_ sender: UIButton) {
        let menu = createMenu(with: sender)
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
            if indexPath.row < vm.getStocksDetailCount() {
                let stocks = vm.getStockInfo(at: indexPath.row)
                let stockDetail = vm.getStockDetail(at: indexPath.row)
                let previousClo = vm.getPreviousCloValue(for: stocks.cod ?? "")
                let previousLas = vm.getPreviousLasValue(for: stocks.cod ?? "")
                
                let model = StockCellModel(stocks: stocks,
                                           stockDetail: stockDetail,
                                           previousClo: previousClo,
                                           selectedKeyForFirstButton: vm.selectedKeyForFirstButton,
                                           selectedKeyForSecondButton: vm.selectedKeyForSecondButton,
                                           previousLasValue: previousLas)
                cell.configureCell(with: model)
                
                vm.updatePreviousCloValue(for: stocks.cod ?? "", with: stockDetail.clo ?? "")
                vm.updatePreviousLasValue(for: stocks.cod ?? "", with: stockDetail.las ?? "")
            }
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

extension StocksViewController: StocksViewModelDelegate {
    func didUpdateStockDetails() {
        DispatchQueue.main.async {
            if let indexPaths = self.tableView.indexPathsForVisibleRows {
                self.tableView.reloadRows(at: indexPaths, with: .none)
            } else {
                print("No visible cells")
            }
        }
    }
}
