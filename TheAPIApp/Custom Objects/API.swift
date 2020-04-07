//
//  API.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/15/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

struct API : Hashable, Codable {
    
    let count : Int
    let entries : [Entry]
}

struct Entry : Hashable, Codable {
    let api : String
    let description : String
    let auth : String?
    let https : Bool
    let cors : String
    let link : String
    let category : String
    
    
    // MARK: custom coding key to handle uppercase keys from JSON data
    private enum CodingKeys : String, CodingKey {
        case api = "API", description = "Description", auth = "Auth", https = "HTTPS", cors = "Cors", link = "Link", category = "Category"
    }
}
    

    

