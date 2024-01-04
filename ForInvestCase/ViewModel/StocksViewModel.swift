//
//  ViewModel.swift
//  ForInvestCase
//
//  Created by Doğa Erdemir on 3.01.2024.
//

import Foundation

class StocksViewModel {
    
    var mypageDefaults: [MypageDefault] = []
    var mypage: [Mypage] = []
    var l: [L] = []
    
    func fetchStocksAndMenus(completion: @escaping (Result<String?, ErrorType>) -> Void) {
        NetworkManager.shared.fetchData(type: StocksModel.self, url: URLs.stockSettingsURL) { [weak self] result in
            switch result {
                case .success(let data):
                    self?.mypageDefaults = data.mypageDefaults ?? []
                    self?.mypage = data.mypage ?? []
                    NetworkManager.shared.fetchData(type: StocksDetailsModel.self, url: URLs.stockDetailURL(with: data.mypageDefaults?.compactMap({$0.tke}) ?? [])) { [weak self] result in
                        switch result {
                            case .success(let dataa):
                                self?.l = dataa.l ?? []
                                completion(.success(""))
                            case .failure(let error):
                                completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func fetchStockValues(completion: @escaping (Result<String?, ErrorType>) -> Void) {
        
    }
    
    func getStocks() -> [MypageDefault] {
        return mypageDefaults
    }
    
    func getStocksCount() -> Int {
        return mypageDefaults.count
    }
    
    func getMenus() -> [Mypage] {
        return mypage
    }
    
    func getMenusCount() -> Int {
        return mypage.count
    }
    
    /*func getStock(at index: Int) -> String {
        return stocks[index].mypageDefaults
    }*/
    
    /*func getStock(at index: Int) -> String {
        return stocks[index].mypageDefaults?[0].def ?? ""
    }*/
}
