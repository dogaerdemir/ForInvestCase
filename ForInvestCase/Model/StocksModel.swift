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
    
    enum CodingKeys: CodingKey {
        case mypageDefaults
        case mypage
    }
}

// MARK: - MypageDefault
struct MypageDefault: Codable {
    var cod, gro, tke, def: String?
    
    enum CodingKeys: CodingKey {
        case cod
        case gro
        case tke
        case def
    }
}

// MARK: - Mypage
struct Mypage: Codable {
    var name, key: String?
}



// MARK: - Other URL
// MARK: - Welcome2
struct StocksDetailsModel: Codable {
    var l: [L]?
    var z: String?
}

// MARK: - L
struct L: Codable {
    var tke, clo, pdd, las: String?
}
