//
//  StockCellModel.swift
//  ForInvestCase
//
//  Created by Doğa Erdemir on 5.01.2024.
//

import Foundation

struct StockCellModel {
    let stocks: MypageDefault?
    let stockDetail: L?
    var previousClo: String?
    let selectedKeyForFirstButton: String?
    let selectedKeyForSecondButton: String?
    let previousLasValue: String?
}

struct PreviousValues {
    var clo: String?
    var las: String?
}

struct SelectedKeys {
    var firstButton: String?
    var secondButton: String?
}
