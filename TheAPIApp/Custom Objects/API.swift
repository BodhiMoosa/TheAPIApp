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
    let API : String
    let Description : String
    let Auth : String?
    let HTTPS : Bool
    let Cors : String
    let Link : String
    let Category : String
}
    

    

    

