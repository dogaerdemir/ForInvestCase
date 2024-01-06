//
//  StocksModel.swift
//  ForInvestCase
//
//  Created by Doğa Erdemir on 3.01.2024.
//

import Foundation

// MARK: - StocksModel
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


// MARK: - Second URL


// MARK: - StocksDetailsModel
struct StocksDetailsModel: Codable {
    var l: [L]?
    var z: String?
}

// MARK: - L
struct L: Codable {
    var tke, clo, pdd, low, ddi, hig, las, pdc: String?
    
    func getValue(for key: String) -> String? {
        switch key {
            case "tke": return tke
            case "clo": return clo
            case "pdd": return pdd
            case "low": return low
            case "ddi": return ddi
            case "hig": return hig
            case "las": return las
            case "pdc": return pdc
            default: return nil
        }
    }
}
