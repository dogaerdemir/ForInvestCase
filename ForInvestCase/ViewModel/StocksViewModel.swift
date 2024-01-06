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
    private var previousLasValues: [String: String] = [:]
    
    var selectedKeyForFirstButton: String?
    var selectedKeyForSecondButton: String?
    
    func updatePreviousCloValue(for cod: String, with value: String) {
        previousCloValues[cod] = value
    }
    
    func getPreviousCloValue(for cod: String) -> String? {
        return previousCloValues[cod]
    }
    
    func updatePreviousLasValue(for las: String, with value: String) {
        previousCloValues[las] = value
    }
    
    func getPreviousLasValue(for las: String) -> String? {
        return previousCloValues[las]
    }
    
    func fetchStocksAndMenus(completion: @escaping (Result<String?, ErrorType>) -> Void) {
        NetworkManager.shared.fetchData(type: StocksModel.self, url: URLs.stockSettingsURL) { [weak self] result in
            switch result {
                case .success(let data):
                    self?.mypageDefaults = data.mypageDefaults ?? []
                    self?.mypage = data.mypage ?? []
                    self?.selectedKeyForFirstButton = self?.mypage[0].key
                    self?.selectedKeyForSecondButton = self?.mypage[1].key
                    self?.setupContinuousRequests(with: data.mypageDefaults?.compactMap { $0.tke } ?? [], forKeys: data.mypage?.compactMap { $0.key } ?? [] )
                    completion(.success(""))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func setupContinuousRequests(with tkeValues: [String], forKeys keys: [String]) {
        let detailURL = URLs.stockDetailURL(with: tkeValues, forKeys: keys)
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.fetchStockDetails(url: detailURL)
            }
            RunLoop.main.add(self.timer!, forMode: .common)
        }
    }
    
    func fetchStockDetails(url: String) {
        var mockStockDetails = [L]()
        for stock in mypageDefaults {
            let mockDetail = L(
                tke: stock.tke,
                clo: "\(Int.random(in: 1...24)):\(Int.random(in: 0...59))",
                pdd: "\(Double.random(in: -2.0...2.0).formatted(.number.precision(.fractionLength(2))))%",
                low: "\(Double.random(in: 100.0...200.0).formatted(.number.precision(.fractionLength(2))))",
                ddi: "\(Double.random(in: -10.0...10.0).formatted(.number.precision(.fractionLength(2))))",
                hig: "\(Double.random(in: 100.0...200.0).formatted(.number.precision(.fractionLength(2))))",
                las: "\(Double.random(in: 100.0...200.0).formatted(.number.precision(.fractionLength(2))))",
                pdc: "\(Double.random(in: 100.0...200.0).formatted(.number.precision(.fractionLength(2))))"
            )
            mockStockDetails.append(mockDetail)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.stocksDetails = mockStockDetails
            self?.delegate?.didUpdateStockDetails()
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
