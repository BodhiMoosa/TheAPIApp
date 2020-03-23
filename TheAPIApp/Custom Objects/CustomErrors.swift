//
//  CustomErrors.swift
//  TheAPIApp
//
//  Created by Tayler Moosa on 3/16/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

enum CustomErrors : String, Error {
    case networkError           = "Network Error"
    case dataError              = "Data Error"
    case cannotSaveFavorite     = "There was an error saving this API. Please try again."
    case cannotDeleteFavorite   = "There was an error deleting this Favorite. Please try again."
}
