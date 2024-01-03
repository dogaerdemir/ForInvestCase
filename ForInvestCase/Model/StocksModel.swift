//
//  StocksModel.swift
//  ForInvestCase
//
//  Created by Doğa Erdemir on 3.01.2024.
//

import Foundation

// MARK: - Welcome
struct StocksModel: Codable {
    var mypageDefaults: [MypageDefault]?
    var mypage: [Mypage]?
}

// MARK: - Mypage
struct Mypage: Codable {
    var name, key: String?
}

// MARK: - MypageDefault
struct MypageDefault: Codable {
    var cod, gro, tke, def: String?
}





// MARK: - Welcome2
struct Welcome2: Codable {
    var l: [L]?
    var z: String?
}

// MARK: - L
struct L: Codable {
    var tke, clo, pdd, las: String?
}
