//
//  ViewController.swift
//  ForInvestCase
//
//  Created by Doğa Erdemir on 3.01.2024.
//

import UIKit

class StocksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    let viewModel = StocksViewModel()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        tableView.register(UINib(nibName: "StocksTableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
        
        fetchData()
    }
    
    private func setupMenuButtons() {
        leftButton.menu = createMenu(with: leftButton)
        leftButton.showsMenuAsPrimaryAction = true
        
        rightButton.menu = createMenu(with: rightButton)
        rightButton.showsMenuAsPrimaryAction = true
    }
    
    private func fetchData() {
        activityIndicator.startAnimating()
        viewModel.fetchStocksAndMenus { [weak self] result in
            guard let self else { return }
            
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.setupMenuButtons()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.showAlert(title: "Error", message: error.errorMessage, actions: ("Dismiss", .default, nil), ("Retry", .cancel, { _ in
                            self.fetchData()
                        })
                        )
                    }
            }
        }
    }
    
    private func createMenu(with button: UIButton) -> UIMenu {
        var actions: [UIAction] = []
        
        for menuOption in viewModel.getMenus() {
            let isSelected = (button.tag == 1 && viewModel.selectedKeys.firstButton == menuOption.key) ||
            (button.tag == 2 && viewModel.selectedKeys.secondButton == menuOption.key)
            
            let action = UIAction(title: menuOption.name ?? "N/A", state: isSelected ? .on : .off) { [weak self] _ in
                if button.tag == 1 {
                    self?.viewModel.selectedKeys.firstButton = menuOption.key
                } else if button.tag == 2 {
                    self?.viewModel.selectedKeys.secondButton = menuOption.key
                }
                button.setTitle(menuOption.name, for: .normal)
                self?.tableView.reloadData()
                button.menu = self?.createMenu(with: button)
            }
            actions.append(action)
        }
        return UIMenu(title: "", children: actions)
    }
}

extension StocksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getStocks().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as? StocksTableViewCell {
            if indexPath.row < viewModel.getStocksDetail().count {
                let stocks = viewModel.getStocks()[indexPath.row]
                let stockDetail = viewModel.getStocksDetail()[indexPath.row]
                let previousValues = viewModel.getPreviousValues(for: stocks.cod ?? "")
                
                let model = StockCellModel(stocks: stocks,
                                           stockDetail: stockDetail,
                                           previousClo: previousValues?.clo,
                                           previousLas: previousValues?.las,
                                           selectedKeyForFirstButton: viewModel.selectedKeyForFirstButton,
                                           selectedKeyForSecondButton: viewModel.selectedKeyForSecondButton)
                cell.configureCell(with: model)
                
                var updatedValues = previousValues ?? PreviousValues()
                updatedValues.clo = stockDetail.clo
                updatedValues.las = stockDetail.las
                viewModel.setPreviousValues(for: stocks.cod ?? "", values: updatedValues)
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension StocksViewController: StocksViewModelDelegate {
    func didFirstUpdate() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func didUpdateStockDetails() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
