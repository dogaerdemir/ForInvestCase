//
//  ViewModel.swift
//  ForInvestCase
//
//  Created by Doğa Erdemir on 3.01.2024.
//

import Foundation

class StocksViewModel {
    
    var stocks: [StocksModel] = []
    
    func fetchData() {
        NetworkManager.shared.fetchData(type: StocksModel.self, url: URLs.stock) { [weak self] result in
            switch result {
            case .success(let data):
                self?.stocks.append(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
