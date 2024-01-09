//
//  ViewModel.swift
//  ForInvestCase
//
//  Created by Doğa Erdemir on 3.01.2024.
//

import Foundation

protocol StocksViewModelDelegate: AnyObject {
    func didUpdateStockDetails()
    func didFirstUpdate()
}

class StocksViewModel {
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    private var networkManager: NetworkManagerProtocol
    private var timer: Timer?
    private var isFirstLoad = false
    weak var delegate: StocksViewModelDelegate?
    
    private var previousValues: [String: PreviousValues] = [:]
    var selectedKeys = SelectedKeys()
    
    private var mypageDefaults: [MypageDefault] = []
    private var mypage: [Mypage] = []
    private var stocksDetails: [L] = []
    
    var selectedKeyForFirstButton: String? {
        get { return selectedKeys.firstButton }
        set { selectedKeys.firstButton = newValue }
    }
    
    var selectedKeyForSecondButton: String? {
        get { return selectedKeys.secondButton }
        set { selectedKeys.secondButton = newValue }
    }
    
    func fetchStocksAndMenus(completion: @escaping (Result<String?, ErrorType>) -> Void) {
        networkManager.fetchData(type: StocksModel.self, url: URLs.stockSettingsURL) { [weak self] result in
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
    
    private func setupContinuousRequests(with tkeValues: [String], forKeys keys: [String]) {
        let detailURL = URLs.stockDetailURL(with: tkeValues, forKeys: keys)
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.fetchStockDetails(url: detailURL)
            }
            RunLoop.main.add(self.timer!, forMode: .common)
        }
    }
    
    private func fetchStockDetails(url: String) {
        networkManager.fetchData(type: StocksDetailsModel.self, url: url) { [weak self] result in
            switch result {
                case .success(let dataa):
                    self?.stocksDetails = dataa.l ?? []
                    if !(self?.isFirstLoad ?? false) {
                        self?.isFirstLoad = true
                        self?.delegate?.didFirstUpdate()
                    } else {
                        self?.delegate?.didUpdateStockDetails()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func getPreviousValues(for cod: String) -> PreviousValues? {
        return previousValues[cod]
    }
    
    func setPreviousValues(for cod: String, values: PreviousValues) {
        previousValues[cod] = values
    }
    
    func getStocks() -> [MypageDefault] {
        return mypageDefaults
    }
    
    func getMenus() -> [Mypage] {
        return mypage
    }
    
    func getStocksDetail() -> [L] {
        return stocksDetails
    }
}
