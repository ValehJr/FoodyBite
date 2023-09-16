//
//  HomeViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 16.09.23.
//


import UIKit
import FirebaseDatabase
import FirebaseStorage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var findRestaurantsField: DesignableUITextField!
    @IBOutlet weak var FriendsSeeButton: UIButton!
    @IBOutlet weak var categorySeeButton: UIButton!
    @IBOutlet weak var trendingSeeButton: UIButton!
    @IBOutlet weak var friendCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    
    var isSearching: Bool = false
    
    let categoryImageNames = ["mexicanFood", "italianFood", "chineseFood", "azerbaijaniFood"]
    let friendsImageNames = ["profile1","profile2","profile3","profile4","profile1","profile2","profile3","profile4","profile1","profile2","profile3","profile4"]
    let cellColors = [UIColor(red: 198/255, green: 61/255, blue: 47/255, alpha: 1),UIColor(red: 226/255, green: 94/255, blue: 62/255, alpha: 1),UIColor(red: 255/255, green: 155/255, blue: 80/255, alpha: 1),UIColor(red: 228/255, green: 133/255, blue: 134/255, alpha: 1)]
    
    var trendingRestaurants: [Restaurants] = []
    var tendingRestaurants: [Restaurants] = []
    var searchResults: [Restaurants] = []
    
    var categories:[String] = []
    
    let ref = Database.database().reference()
    
    let userID = UserData.shared.userID
    
    var hasShuffledTrendingRestaurants = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trendingCollectionView.dataSource = self
        trendingCollectionView.delegate = self
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        friendCollectionView.dataSource = self
        friendCollectionView.delegate = self
        
        findRestaurantsField.attributedPlaceholder = NSAttributedString(string: "Find Restaurants", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 110/255, green: 127/255, blue: 170/255, alpha: 1)])
        findRestaurantsField.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        findRestaurantsField.layer.borderWidth = 1
        findRestaurantsField.layer.cornerRadius = 10
        
        categoryCollectionView.backgroundColor = UIColor.white
        trendingCollectionView.backgroundColor = UIColor.white
        friendCollectionView.backgroundColor = UIColor.white
        
        self.view.backgroundColor = UIColor.white
        
        hideKeyboardWhenTappedAround()
        
        findRestaurantsField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        loadRestaurantDataFromFirebase()
        loadRatingDataFromFirebase()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if animated {
            loadRatingDataFromFirebase()
            self.trendingCollectionView.reloadData()
        }
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
            if let value = snapshot.value as? [String: Any] {
                for (restaurantID, restaurantData) in value {
                    if let restaurant = restaurantData as? [String: Any],
                       let name = restaurant["name"] as? String,
                       let rating = restaurant["rating"] as? Float,
                       let address = restaurant["address"] as? String,
                       let category = restaurant["category"] as? String,
                       let status = restaurant["status"] as? String,
                       let numberOfRatings = restaurant["numberOfRatings"] as? Float,
                       let reviewsData = restaurant["reviews"] as? [[String: Any]],!reviewsData.isEmpty {
                        var reviews: [Review] = []
                        if !self.categories.contains(category) {
                            self.categories.append(category)
                            self.categories = Array(self.categories.prefix(4))
                        }
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
                self.trendingRestaurants.shuffle()
                let randomRestaurants = Array(self.trendingRestaurants.prefix(4))
                self.trendingRestaurants = randomRestaurants
                self.tendingRestaurants = self.trendingRestaurants
                self.trendingCollectionView.reloadData()
                self.categories.sort()
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    func loadRatingDataFromFirebase() {
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
                       let reviewsData = restaurant["reviews"] as? [[String: Any]],!reviewsData.isEmpty {
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
                        self.tendingRestaurants = self.trendingRestaurants
                    } else {
                        print("Failed to unwrap values for a restaurant.")
                    }
                }
                self.trendingRestaurants = Array(self.trendingRestaurants.prefix(4))
                self.trendingCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func trendingSeeButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "goToTrending", sender: self)
    }
    
    @IBAction func categorySeeButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCategories", sender: self)
        
    }
    
    @IBAction func friendsSeeButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "goToFriends", sender: self)
    }
    
}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count
        }
        if collectionView == trendingCollectionView {
            return trendingRestaurants.count
        }
        if collectionView == friendCollectionView {
            return friendsImageNames.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryID", for: indexPath) as! CategoryCollectionViewCell
            let categoryName = categories[indexPath.item]
            cell.categoryView.layer.cornerRadius = 18
            cell.categoryLabel.text = categoryName
            cell.categoryLabel.font = UIFont(name: "JosefinSans-Semibold", size: 17)
            let colorIndex = indexPath.item % cellColors.count
            cell.backgroundViewColor.backgroundColor = cellColors[colorIndex]
            return cell
        } else if collectionView == trendingCollectionView {
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
            cell.collectionView.backgroundColor = UIColor.white
            cell.collectionView.layer.cornerRadius = 10
            cell.collectionView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
            cell.collectionView.layer.borderWidth = 1
            cell.collectionView.layer.cornerRadius = 10
            return cell
        } else if collectionView == friendCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsID", for: indexPath) as! FriendsCollectionViewCell
            let imageName = friendsImageNames[indexPath.item]
            cell.profileImage.image = UIImage(named: imageName)
            cell.friendsView.layer.cornerRadius = cell.friendsView.frame.height / 2
            cell.friendsView.clipsToBounds = true
            return cell
        }
        return UICollectionViewCell()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCategory" {
            if let destVC = segue.destination as? CategoryViewController, let selectedCategory = sender as? String{
                destVC.selectedCategory = selectedCategory
            }
        }
        if segue.identifier == "goToRestaurant" {
            if let destVC = segue.destination as? RestaurantsViewController, let selectedRestaurant = sender as? Restaurants{
                destVC.selectedRestaurant = selectedRestaurant
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == categoryCollectionView {
            let selectedCategory = categories[indexPath.item]
            performSegue(withIdentifier: "goToCategory", sender: selectedCategory)
        }
        if collectionView == trendingCollectionView {
            let selectedRestaurant = trendingRestaurants[indexPath.item]
            performSegue(withIdentifier: "goToRestaurant", sender: (selectedRestaurant))
        }
        if collectionView == friendCollectionView {
            //performSegue(withIdentifier: "FriendSegueIdentifier", sender: indexPath)
        }
    }
}
