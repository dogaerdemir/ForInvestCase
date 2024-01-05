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
    private static let base = "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/"
    static let stockSettingsURL = base + "ForeksMobileInterviewSettings"
    
    static func stockDetailURL(with tkeValues: [String]) -> String {
        let tkeParameter = tkeValues.joined(separator: "~")
        return base + "ForeksMobileInterview?fields=pdd,las&stcs=" + tkeParameter
    }
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
