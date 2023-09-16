//
//  CategoryViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 16.10.23.
//

import UIKit
import FirebaseDatabase

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var restaurantCollectionView: UICollectionView!
    
    var selectedCategory:String?
    var selectedColor: UIColor?
    
    var ref = Database.database().reference()
    
    let cellColors = [UIColor(red: 198/255, green: 61/255, blue: 47/255, alpha: 1),UIColor(red: 226/255, green: 94/255, blue: 62/255, alpha: 1),UIColor(red: 255/255, green: 155/255, blue: 80/255, alpha: 1),UIColor(red: 228/255, green: 133/255, blue: 134/255, alpha: 1),UIColor(red: 92/255, green: 75/255, blue: 153/255, alpha: 1),UIColor(red: 103/255, green: 65/255, blue: 136/255, alpha: 1),UIColor(red: 145/255, green: 109/255, blue: 179/255, alpha: 1),UIColor(red: 159/255, green: 145/255, blue: 204/255, alpha: 1)]
    
    var categoryRestaurant: [Restaurants] = []
    
    var restaurants:[Restaurants] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantCollectionView.delegate = self
        restaurantCollectionView.dataSource = self
        restaurantCollectionView.backgroundColor = UIColor.white
        
        if let category = selectedCategory {
            categoryLabel.text = category
        }
        
        if let category = selectedCategory {
            categoryLabel.text = category
            switch category {
            case "Mexican":
                coloredView.backgroundColor = cellColors[7]
            case "Italian":
                coloredView.backgroundColor = cellColors[5]
            case "Chinese":
                coloredView.backgroundColor = cellColors[2]
            case "Azerbaijani":
                coloredView.backgroundColor = cellColors[1]
            case "French":
                coloredView.backgroundColor = cellColors[3]
            case "Japanese":
                coloredView.backgroundColor = cellColors[6]
            case "Indian":
                coloredView.backgroundColor = cellColors[4]
            case "American":
                coloredView.backgroundColor = cellColors[0]
            default:
                coloredView.backgroundColor = .white
            }
        }
        
        loadRestaurantDataFromFirebase()
    }
    
    func loadRestaurantDataFromFirebase() {
        ref.child("restaurants").observeSingleEvent(of: .value) { (snapshot) in
            self.restaurants.removeAll()
            
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
                        if  category == self.selectedCategory{
                            for reviewData in reviewsData {
                                if let userID = reviewData["userID"] as? String,
                                   let reviewText = reviewData["reviewText"] as? String,
                                   let userRating = reviewData["userRating"] as? Float {
                                    let review = Review(userID: userID, reviewText: reviewText, userRating: userRating,userName: "",userProfilePictureURL: "")
                                    reviews.append(review)
                                }
                            }
                            let restaurant = Restaurants(id: restaurantID, name: name, rating: rating, address: address, category: category, status: status, numberOfRatings: numberOfRatings, reviews: reviews)
                            self.restaurants.append(restaurant)
                        }
                    } else {
                        print("Failed to unwrap values for a restaurant.")
                    }
                }
            }
            
            self.restaurantCollectionView.reloadData()
        }
    }
    
}

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryRestaurantID", for: indexPath) as! TrendingCollectionViewCell
        cell.backgroundColor = UIColor.white
        
        let restaurant = restaurants[indexPath.item]
        configureCell(cell, restaurant: restaurant)
        
        cell.collectionView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        cell.collectionView.layer.borderWidth = 1
        cell.collectionView.layer.cornerRadius = 10
        
        return cell
    }
    
    func configureCell(_ cell: TrendingCollectionViewCell, restaurant: Restaurants) {
        cell.nameLabel.text = restaurant.name
        cell.categoryLabel.text = restaurant.category
        cell.addressLabel.text = restaurant.address
        cell.ratingLabel.text = "\(restaurant.rating)"
        cell.conditionLabel.text = restaurant.status
    }
    
    
}

extension CategoryViewController: UICollectionViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRestaurant" {
            if let destVC = segue.destination as? RestaurantsViewController, let selectedRestaurant = sender as? Restaurants {
                destVC.selectedRestaurant = selectedRestaurant
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedRestaurant = restaurants[indexPath.item]
        performSegue(withIdentifier: "goToRestaurant", sender: (selectedRestaurant))
    }
}
