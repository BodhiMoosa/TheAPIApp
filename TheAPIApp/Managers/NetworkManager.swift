//
//  NetworkManager.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/15/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

class Networkmanager {
    static let shared = Networkmanager()
    
    private init() {}
    
    func getAPIS(completed: @escaping ((Result<API,CustomErrors>) -> Void)) {
        let baseURL     = "https://api.publicapis.org/entries"
        guard let url   = URL(string: baseURL) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error  {
                completed(.failure(.networkError))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.networkError))
                return
            }
            guard let data = data else {
                completed(.failure(.networkError))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let apiData = try decoder.decode(API.self, from: data)
                completed(.success(apiData))
            } catch {
                completed(.failure(.dataError))
            }
        }
        task.resume()
    }
    
    func getAPICategories(completed: @escaping ((Result<[String],CustomErrors>) -> Void)) {
    
        guard let url = URL(string: "https://api.publicapis.org/categories") else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error  {
                completed(.failure(.networkError))
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.networkError))
                return
            }
            guard let data = data else {
                completed(.failure(.networkError))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let apiData = try decoder.decode([String].self, from: data)
                completed(.success(apiData))
            } catch {
                completed(.failure(.dataError))
            }
        }
        task.resume()
    }
    
    func getAllForCategory(category: String, completed: @escaping ((Result<API,CustomErrors>) -> Void)) {
    
        guard let url = URL(string: "https://api.publicapis.org/entries?category=" + category) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error  {
                completed(.failure(.networkError))
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.networkError))
                return
            }
            guard let data = data else {
                completed(.failure(.networkError))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let apiData = try decoder.decode(API.self, from: data)
                completed(.success(apiData))
            } catch {
                completed(.failure(.dataError))
            }
        }
        task.resume()
    }
}
