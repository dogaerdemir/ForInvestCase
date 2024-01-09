//
//  NetworkManager.swift
//  ForInvestCase
//
//  Created by Doğa Erdemir on 3.01.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(type: T.Type, url: String, completion: @escaping (Result<T, ErrorType>) -> Void)
}

enum ErrorType: Error {
    case serverError(String)
    case parsingError(String)
    
    var errorMessage: String {
        switch self {
            case .serverError(let message):
                return message
            case .parsingError(let message):
                return message
        }
    }
}

enum URLs {
    private static let base = "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/"
    static let stockSettingsURL = base + "ForeksMobileInterviewSettings"
    
    static func stockDetailURL(with tkeValues: [String], forKeys keys: [String]) -> String {
        let tkeParameter = tkeValues.joined(separator: "~")
        let fieldsParameter = keys.joined(separator: ",")
        return base + "ForeksMobileInterview?fields=" + fieldsParameter + "&stcs=" + tkeParameter
    }
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData<T: Decodable>(type: T.Type, url: String, completion: @escaping (Result<T, ErrorType>) -> ()) {
        guard let url = URL(string: url) else { return }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: config)
        
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(.serverError("Server Error: \(error.localizedDescription)")))
            } else if let data = data {
                do {
                    let dataModel = try JSONDecoder().decode(type.self, from: data)
                    completion(.success(dataModel))
                } catch {
                    completion(.failure(.parsingError("Data Parsing Error: \(error.localizedDescription)")))
                }
            }
        }.resume()
    }
}
