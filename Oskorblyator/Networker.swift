//
//  Networker.swift
//  Oskorblyator
//
//  Created by Иван Маришин on 26.06.2021.
//

import Foundation

enum NetworkerError: Error {
    case badResponse
    case badStatusCode(Int)
    case badData
}

class Networker {
    
    static let shared = Networker()
    
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func getQuote(completion: @escaping (Quote?, Error?) -> (Void)) {
        let url = URL(string: "https://evilinsult.com/generate_insult.php?lang=en&type=json")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(nil, NetworkerError.badResponse)
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(nil, NetworkerError.badStatusCode(httpResponse.statusCode))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, NetworkerError.badData)
                }
                return
            }
            
            do {
                let quote = try JSONDecoder().decode(Quote.self, from: data)
                DispatchQueue.main.async {
                    completion(quote, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
