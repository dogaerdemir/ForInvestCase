//
//  ViewModel.swift
//  ForInvestCase
//
//  Created by Doğa Erdemir on 3.01.2024.
//

import Foundation

protocol StocksViewModelDelegate: AnyObject {
    func didUpdateStockDetails()
}

class StocksViewModel {
    
    weak var delegate: StocksViewModelDelegate?
    
    private var timer: Timer?
    
    private var mypageDefaults: [MypageDefault] = []
    private var mypage: [Mypage] = []
    private var stocksDetails: [L] = []
    
    private var previousCloValues: [String: String] = [:]
    
    func updatePreviousCloValue(for cod: String, with value: String) {
        previousCloValues[cod] = value
    }
    
    func getPreviousCloValue(for cod: String) -> String? {
        return previousCloValues[cod]
    }
    
    func fetchStocksAndMenus(completion: @escaping (Result<String?, ErrorType>) -> Void) {
        NetworkManager.shared.fetchData(type: StocksModel.self, url: URLs.stockSettingsURL) { [weak self] result in
            switch result {
                case .success(let data):
                    self?.mypageDefaults = data.mypageDefaults ?? []
                    self?.mypage = data.mypage ?? []
                    self?.setupContinuousRequests(with: data.mypageDefaults?.compactMap { $0.tke } ?? [])
                    completion(.success(""))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func setupContinuousRequests(with tkeValues: [String]) {
        let detailURL = URLs.stockDetailURL(with: tkeValues)
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.fetchStockDetails(url: detailURL)
            }
            RunLoop.main.add(self.timer!, forMode: .common)
        }
    }
    
    func fetchStockDetails(url: String) {
        NetworkManager.shared.fetchData(type: StocksDetailsModel.self, url: url) { [weak self] result in
            switch result {
                case .success(let dataa):
                    self?.stocksDetails = dataa.l ?? []
                    self?.delegate?.didUpdateStockDetails()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func getStocksInfo() -> [MypageDefault] {
        return mypageDefaults
    }
    
    func getStockInfo(at index: Int) -> MypageDefault {
        return mypageDefaults[index]
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
    
    func getMenu(at index: Int) -> Mypage {
        return mypage[index]
    }
    
    
    func getStocksDetail() -> [L] {
        return stocksDetails
    }
    
    func getStockDetail(at index: Int) -> L {
        return stocksDetails[index]
    }
    
    func getStocksDetailCount() -> Int {
        return stocksDetails.count
    }
}
