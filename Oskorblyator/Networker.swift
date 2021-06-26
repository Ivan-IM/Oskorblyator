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
    
    func getQuote(completion: @escaping (SimpleNetworkStruct?, Error?) -> (Void)) {
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
                let answer = try JSONDecoder().decode(SimpleNetworkStruct.self, from: data)
                DispatchQueue.main.async {
                    completion(answer, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    func getImage(completion: @escaping (Data?, Error?) -> (Void)) {
        let urlList: Array<String> = [
            "https://c.tcdn.co/8a3/9de/8a39de9c-bd76-11ea-ba0f-96000024ad61/channel256.png",
            "https://i.pinimg.com/originals/41/f6/42/41f642e83d763339d66772fe9ff3b5c6.jpg",
            "https://apkshki.com/storage/4915/icon_5f297702cb229_4915_w256.png",
            "https://i.pinimg.com/originals/2d/fb/3c/2dfb3c9d861b494c80da8c7a79b3d301.jpg",
            "https://lh3.googleusercontent.com/proxy/3n_KK6rmn5ueDmj4I4x5m5OwVc7Ky-BImOUGPmwHqT9OWxNLXwuhGJZiVwAMJ_nfemsRoQ5PAMi_VSq_hPMSwvCU0dFuSLmUCfkhCg3DlXho",
        ]
        let url = URL(string: urlList.randomElement()!)!
      
      let task = session.downloadTask(with: url) { (localUrl: URL?, response: URLResponse?, error: Error?) in
        
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
        
        guard let localUrl = localUrl else {
          DispatchQueue.main.async {
            completion(nil, NetworkerError.badData)
          }
          return
        }
        
        do {
          let data = try Data(contentsOf: localUrl)
          DispatchQueue.main.async {
            completion(data, nil)
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
