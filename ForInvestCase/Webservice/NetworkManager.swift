//
//  NetworkManager.swift
//  ForInvestCase
//
//  Created by Doğa Erdemir on 3.01.2024.
//

import Foundation

enum ErrorType : Error {
    case serverError
    case parsingError
}

enum URLs {
    static let stock = "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterviewSettings"
    static let stockDetail = "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterview?fields=pdd,las&stcs=GARAN.E.BIST~XU100.I.BIST"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData<T: Decodable>(type: T.Type, url: String, completion: @escaping (Result<T, ErrorType>) -> ()) {
        guard let url = URL(string: url) else { return }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let data {
                do {
                    let dataModel = try JSONDecoder().decode(type.self, from: data)
                    completion(.success(dataModel))
                } catch {
                    completion(.failure(.parsingError))
                }
            } else {
                completion(.failure(.serverError))
            }
        }.resume()
    }
}
