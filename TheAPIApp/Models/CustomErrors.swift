//
//  CustomErrors.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/16/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

enum CustomErrors : String, Error {
    case networkError = "Network Error"
    case dataError    = "Data Error"
}
