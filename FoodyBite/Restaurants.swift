//
//  Restaurants.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 22.09.23.
//

import Foundation

struct Categories {
    var italian: [Restaurants]
    var mexican: [Restaurants]
    var azerbaijani: [Restaurants]
    var japanese: [Restaurants]
    var chinese: [Restaurants]
    var french: [Restaurants]
    var indian: [Restaurants]
    var american: [Restaurants]
}

@objc class Review: NSObject {
    @objc var userID: String
    @objc var reviewText: String
    @objc var userRating: Float
    @objc var userName: String
    @objc var userProfilePictureURL: String

    @objc init(userID: String, reviewText: String, userRating: Float,userName:String,userProfilePictureURL:String) {
        self.userID = userID
        self.reviewText = reviewText
        self.userRating = userRating
        self.userName = userName
        self.userProfilePictureURL = userProfilePictureURL
    }
}


struct Restaurants {
    var id:String
    var name:String
    var rating:Float
    var address:String
    var category:String
    var status:String
    var numberOfRatings:Float
    var reviews:[Review]
}

let italianRestaurants: [Restaurants] = [
    Restaurants(id:"",name: "Bella Vita Ristorante", rating: 4.5, address: "123 Main Street", category: "Italian", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "Il Piatto D'Oro", rating: 4.5, address: "456 Pasta Avenue", category: "Italian", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "Pasta Pronto Pizzeria", rating: 4.5, address: "789 Olive Lane", category: "Italian", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")])
]

let mexicanRestaurants: [Restaurants] = [
    Restaurants(id:"",name: "Casa del Sabor Mexicano", rating: 4.5, address: "321 Sombrero Street", category: "Mexican", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "Tacos y Tequila Cantina", rating: 4.5, address: "654 Margarita Avenue", category: "Mexican", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "La Fiesta Taqueria", rating: 4.5, address: "987 Salsa Road", category: "Mexican", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")])
]

let azerbaijaniRestaurants: [Restaurants] = [
    Restaurants(id:"",name: "Caspian Flavors", rating: 4.5, address: "111 Baku Boulevard", category: "Azerbaijani", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "Baku Delights", rating: 4.5, address: "222 Azerbaijani Avenue", category: "Azerbaijani", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "Azeri Palace Restaurant", rating: 4.5, address: "333 Caspian Square", category: "Azerbaijani", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")])
]

let japaneseRestaurants: [Restaurants] = [
    Restaurants(id:"",name: "Sakura Sushi & Grill", rating: 4.5, address: "555 Cherry Blossom Lane", category: "Japanese", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "Kaiseki Harmony", rating: 4.5, address: "777 Zen Garden Street", category: "Japanese", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "Umami Ramen House", rating: 4.5, address: "999 Ramen Road", category: "Japanese", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")])
]

let chineseRestaurants: [Restaurants] = [
    Restaurants(id:"",name: "Dragon Wok Express", rating: 4.5, address: "444 Dragon Street", category: "Chinese", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "Panda Garden Restaurant", rating: 4.5, address: "666 Bamboo Avenue", category: "Chinese", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "Szechuan Palace", rating: 4.5, address: "888 Spice Lane", category: "Chinese", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")])
]

let frenchRestaurants: [Restaurants] = [
    Restaurants(id:"",name: "Le Petit Bistro", rating: 4.5, address: "French Riviera Boulevard", category: "French", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "C'est Si Bon Café", rating: 4.5, address: "Croissant Lane", category: "French", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "La Patisserie Royale", rating: 4.5, address: "Eclair Avenue", category: "French", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")])
]

let indianRestaurants: [Restaurants] = [
    Restaurants(id:"",name: "Taj Mahal Indian Cuisine", rating: 4.5, address: "Curry Street", category: "Indian", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "Maharaja's Feast", rating: 4.5, address: "Tandoori Avenue", category: "Indian", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "Curry House Delights", rating: 4.5, address: "Masala Lane", category: "Indian", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")])
]

let americanRestaurants: [Restaurants] = [
    Restaurants(id:"",name: "Liberty Grill & Bar", rating: 4.5, address: "Freedom Avenue", category: "American", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "Red, White, & Burger", rating: 4.5, address: "Burger Street", category: "American", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")]),
    Restaurants(id:"",name: "Star-Spangled Steakhouse", rating: 4.5, address: "Steak Road", category: "American", status: "open",numberOfRatings: 0,reviews: [Review(userID: "", reviewText: "", userRating: 0,userName: "",userProfilePictureURL: "")])
]


let categories = Categories(italian: italianRestaurants, mexican: mexicanRestaurants, azerbaijani: azerbaijaniRestaurants, japanese: japaneseRestaurants,chinese: chineseRestaurants,french: frenchRestaurants,indian: indianRestaurants,american: americanRestaurants)

