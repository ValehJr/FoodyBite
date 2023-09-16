//
//  RestaurantManager.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 29.10.23.
//

import Foundation

class RestaurantManager {
    static let shared = RestaurantManager()

    var categories: Categories
    var categoryNames: [String]

    private init() {
        categories = Categories(
            italian: italianRestaurants,
            mexican: mexicanRestaurants,
            azerbaijani: azerbaijaniRestaurants,
            japanese: japaneseRestaurants,
            chinese: chineseRestaurants,
            french: frenchRestaurants,
            indian: indianRestaurants,
            american: americanRestaurants
        )
        categoryNames = ["Mexican", "Italian", "Chinese", "Azerbaijani", "French", "Japanese", "Indian", "American"]
    }
}
