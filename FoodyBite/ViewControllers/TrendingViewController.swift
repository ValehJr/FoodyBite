//
//  TrendingViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 30.09.23.
//

import UIKit
import FirebaseDatabase
import Firebase

class TrendingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var findRestaurantsField: DesignableUITextField!
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    
    var trendingRestaurants: [Restaurants] = []
    var tendingRestaurants: [Restaurants] = []
    var searchResults: [Restaurants] = []
    
    var userID = UserData.shared.userID
    
    let ref = Database.database().reference()
    
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trendingCollectionView.dataSource = self
        trendingCollectionView.delegate = self
        
        findRestaurantsField.delegate = self
        
        
        trendingCollectionView.backgroundColor = UIColor.white
        
        findRestaurantsField.attributedPlaceholder = NSAttributedString(string: "Find Restaurants", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 110/255, green: 127/255, blue: 170/255, alpha: 1)])
        findRestaurantsField.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        findRestaurantsField.layer.borderWidth = 1
        findRestaurantsField.layer.cornerRadius = 10
        
        self.view.backgroundColor = UIColor.white
        
        
        
        findRestaurantsField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        hideKeyboardWhenTappedAround()
        
        loadRestaurantDataFromFirebase()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let searchText = findRestaurantsField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
            searchRestaurants(withText: searchText)
            isSearching = true
        } else {
            trendingRestaurants = tendingRestaurants
            isSearching = false
        }
        trendingCollectionView.reloadData()
    }
    
    func searchRestaurants(withText searchText: String) {
        searchResults = []
        ref.child("restaurants").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                for (restaurantID, restaurantData) in value {
                    if let restaurant = restaurantData as? [String: Any],
                       let name = restaurant["name"] as? String,
                       let rating = restaurant["rating"] as? Float,
                       let address = restaurant["address"] as? String,
                       let category = restaurant["category"] as? String,
                       let status = restaurant["status"] as? String,
                       let numberOfRatings = restaurant["numberOfRatings"] as? Float,
                       let reviewsData = restaurant["reviews"] as? [[String: Any]] {
                        var reviews: [Review] = []
                        
                        for reviewData in reviewsData {
                            if let userID = reviewData["userID"] as? String,
                               let reviewText = reviewData["reviewText"] as? String,
                               let userRating = reviewData["userRating"] as? Float {
                                let review = Review(userID: userID, reviewText: reviewText, userRating: userRating,userName: "",userProfilePictureURL: "")
                                reviews.append(review)
                            }
                        }
                        
                        let restaurant = Restaurants(id: restaurantID, name: name, rating: rating, address: address, category: category, status: status, numberOfRatings: numberOfRatings, reviews: reviews)
                        
                        if self.isSearching && restaurant.name.lowercased().contains(searchText.lowercased()) {
                            self.searchResults.append(restaurant)
                            self.trendingRestaurants = self.searchResults
                        }
                    }
                }
            }
            self.trendingCollectionView.reloadData()
        }
    }
    
    func loadRestaurantDataFromFirebase() {
        ref.child("restaurants").observeSingleEvent(of: .value) { (snapshot) in
            self.trendingRestaurants.removeAll()
            
            if let value = snapshot.value as? [String: Any] {
                for (restaurantID, restaurantData) in value {
                    if let restaurant = restaurantData as? [String: Any],
                       let name = restaurant["name"] as? String,
                       let rating = restaurant["rating"] as? Float,
                       let address = restaurant["address"] as? String,
                       let category = restaurant["category"] as? String,
                       let status = restaurant["status"] as? String,
                       let numberOfRatings = restaurant["numberOfRatings"] as? Float,
                       let reviewsData = restaurant["reviews"] as? [[String: Any]] {
                        var reviews: [Review] = []
                        
                        for reviewData in reviewsData {
                            if let userID = reviewData["userID"] as? String,
                               let reviewText = reviewData["reviewText"] as? String,
                               let userRating = reviewData["userRating"] as? Float {
                                let review = Review(userID: userID, reviewText: reviewText, userRating: userRating,userName: "",userProfilePictureURL: "")
                                reviews.append(review)
                            }
                        }
                        
                        let restaurant = Restaurants(id: restaurantID, name: name, rating: rating, address: address, category: category, status: status, numberOfRatings: numberOfRatings, reviews: reviews)
                        self.trendingRestaurants.append(restaurant)
                    } else {
                        print("Failed to unwrap values for a restaurant.")
                    }
                }
            }
            
            self.trendingRestaurants.shuffle()
            let randomRestaurants = Array(self.trendingRestaurants.prefix(8))
            self.trendingRestaurants = randomRestaurants
            self.tendingRestaurants = self.trendingRestaurants
            self.trendingCollectionView.reloadData()
        }
    }
}

extension TrendingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendingRestaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingID", for: indexPath) as! TrendingCollectionViewCell
        let restaurant = trendingRestaurants[indexPath.item]
        cell.backgroundColor = UIColor.white
        cell.addressLabel.text = restaurant.address
        cell.categoryLabel.text = restaurant.category
        cell.conditionLabel.text = restaurant.status
        cell.ratingLabel.text = String(format:"%.1f",(restaurant.rating))
        cell.nameLabel.text = restaurant.name
        cell.trendingCategoryView.layer.cornerRadius = cell.trendingCategoryView.bounds.height / 2
        cell.trendingDistanceView.layer.cornerRadius = cell.trendingDistanceView.bounds.height / 2
        cell.statusView.layer.cornerRadius = 4
        cell.ratingView.layer.cornerRadius = 4
        cell.statusView.backgroundColor = UIColor.white
        cell.ratingView.backgroundColor = UIColor.white
        cell.collectionView.layer.cornerRadius = 10
        cell.collectionView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        cell.collectionView.layer.borderWidth = 1
        cell.collectionView.layer.cornerRadius = 10
        return cell
    }
    
}

extension TrendingViewController: UICollectionViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRestaurant" {
            if let destVC = segue.destination as? RestaurantsViewController, let selectedRestaurant = sender as? Restaurants {
                destVC.selectedRestaurant = selectedRestaurant
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedRestaurant = trendingRestaurants[indexPath.item]
        performSegue(withIdentifier: "goToRestaurant", sender: (selectedRestaurant))
    }
}
