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
        
        fetchData()
    }
    
    func fetchData() {
        vm.fetchStocksAndMenus { [weak self] result in
            guard let self else { return }
            
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: error.errorMessage, actions: ("Dismiss", .default, nil), ("Retry", .cancel, { _ in
                            self.fetchData()
                        })
                        )
                    }
            }
        }
    }
    
    func createMenu(with button: UIButton) -> UIMenu {
        var actions: [UIAction] = []
        
        for menuOption in vm.getMenus() {
            let isSelected = (button.tag == 1 && vm.selectedKeys.firstButton == menuOption.key) ||
            (button.tag == 2 && vm.selectedKeys.secondButton == menuOption.key)
            
            let action = UIAction(title: menuOption.name ?? "N/A", state: isSelected ? .on : .off) { [weak self] _ in
                if button.tag == 1 {
                    self?.vm.selectedKeys.firstButton = menuOption.key
                } else if button.tag == 2 {
                    self?.vm.selectedKeys.secondButton = menuOption.key
                }
                button.setTitle(menuOption.name, for: .normal)
                self?.tableView.reloadData()
                button.menu = self?.createMenu(with: button)
            }
            actions.append(action)
        }
        return UIMenu(title: "", children: actions)
    }
    
    @IBAction func headerButtonTapped(_ sender: UIButton) {
        let menu = createMenu(with: sender)
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
    }
}

extension StocksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.getStocks().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as? StocksTableViewCell {
            if indexPath.row < vm.getStocksDetail().count {
                let stocks = vm.getStocks()[indexPath.row]
                let stockDetail = vm.getStocksDetail()[indexPath.row]
                let previousValues = vm.getPreviousValues(for: stocks.cod ?? "")
                
                let model = StockCellModel(stocks: stocks,
                                           stockDetail: stockDetail,
                                           previousClo: previousValues?.clo,
                                           previousLas: previousValues?.las,
                                           selectedKeyForFirstButton: vm.selectedKeyForFirstButton,
                                           selectedKeyForSecondButton: vm.selectedKeyForSecondButton)
                cell.configureCell(with: model)
                
                var updatedValues = previousValues ?? PreviousValues()
                updatedValues.clo = stockDetail.clo
                updatedValues.las = stockDetail.las
                vm.setPreviousValues(for: stocks.cod ?? "", values: updatedValues)
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
            }
        }
    }
}
