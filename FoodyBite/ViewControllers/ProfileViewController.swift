//
//  ProfileViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 04.10.23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var recentlyVisitedCollectionView: UICollectionView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followingNumber: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followersNumber: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var reviewNumber: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImageView: UIView!
    
    var recentlyVisited: [Restaurants] = []
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataUpdated), name: Notification.Name("UserDataUpdated"), object: nil)
        
        recentlyVisitedCollectionView.backgroundColor = UIColor.white
        
        recentlyVisitedCollectionView.delegate = self
        recentlyVisitedCollectionView.dataSource = self
        
        settingsButton.layer.borderColor = UIColor(red: 138/255, green: 152/255, blue: 186/255, alpha: 1).cgColor
        settingsButton.layer.borderWidth = 0.3
        settingsButton.layer.cornerRadius = 10
        
        writeTheData()
        
        loadRestaurantData(limit:4)
        //loadRestaurantDataFromFirebase()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }
    
    @IBAction func settingsButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    @objc func userDataUpdated() {
        writeTheData()
    }
    
    func writeTheData() {
        if let uid = Auth.auth().currentUser?.uid {
            print("Fetching data for UID:", uid)
            ref.child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    if let value = snapshot.value as? [String: Any] {
                        if let name = value["name"] as? String, let email = value["email"] as? String, let image = value["profileImageURL"] as? String{
                            let nameComponents = name.components(separatedBy: " ")
                            
                            if nameComponents.count >= 2 {
                                let firstName = nameComponents[0]
                                let lastName = nameComponents.dropFirst().joined(separator: " ")
                                
                                self.nameLabel.text = "\(firstName) \(lastName)"
                            } else {
                                self.nameLabel.text = "\(name)"
                            }
                            self.emailLabel.text = email
                            self.loadImage(from: image)
                        } else {
                            print("Name,email or image data is missing or not in the correct format.")
                        }
                    } else {
                        print("Snapshot value is not a dictionary:", snapshot.value ?? "nil")
                    }
                } else {
                    print("Snapshot does not exist for the given UID.")
                }
            }) { error in
                print("Error fetching user data:", error.localizedDescription)
            }
        } else {
            print("User is not authenticated.")
        }
    }
    
    func loadImage(from imageUrl: String) {
        let storageRef = Storage.storage().reference(forURL: imageUrl)
        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            } else {
                if let imageData = data, let image = UIImage(data: imageData) {
                    self.profileImage.image = image
                } else {
                    print("No valid image data found.")
                }
            }
        }
    }
    
    func loadRestaurantData(limit: Int) {
        if let uid = Auth.auth().currentUser?.uid {
            let recentRef = ref.child("users").child(uid).child("visitedRestaurants").queryLimited(toLast: UInt(limit)).observe(.value) { snapshot in
                self.recentlyVisited.removeAll()
                if let restaurantIDs = snapshot.value as? [String: String] {
                    let restaurantIDsArray = Array(restaurantIDs.values)
                    for restaurantValue in restaurantIDsArray.reversed() {
                        print("Fetching restaurant data for ID: \(restaurantValue)")
                        self.ref.child("restaurants").child(restaurantValue).observeSingleEvent(of: .value) { restSnapshot in
                            if let restaurantData = restSnapshot.value as? [String: Any] {
                                if let name = restaurantData["name"] as? String,
                                   let rating = restaurantData["rating"] as? Float,
                                   let address = restaurantData["address"] as? String,
                                   let category = restaurantData["category"] as? String,
                                   let status = restaurantData["status"] as? String,
                                   let numberOfRatings = restaurantData["numberOfRatings"] as? Float,
                                   let reviewsData = restaurantData["reviews"] as? [[String: Any]] {
                                    var reviews: [Review] = []
                                    for reviewData in reviewsData {
                                        if let userID = reviewData["userID"] as? String,
                                           let reviewText = reviewData["reviewText"] as? String,
                                           let userRating = reviewData["userRating"] as? Float {
                                            let review = Review(userID: userID, reviewText: reviewText, userRating: userRating, userName: "", userProfilePictureURL: "")
                                            reviews.append(review)
                                        }
                                    }
                                    let restaurant = Restaurants(id: restaurantValue, name: name, rating: rating, address: address, category: category, status: status, numberOfRatings: numberOfRatings, reviews: reviews)
                                    self.recentlyVisited.append(restaurant)
                                }
                            } else {
                                print("Failed to unwrap values for a restaurant with ID: \(restaurantValue)")
                            }
                            
                            // Reload the collection view after fetching data for all visited restaurants
                            self.recentlyVisitedCollectionView.reloadData()
                        }
                    }
                } else {
                    print("No value found")
                }
            }
        }
    }


    
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {}
    
}


extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentlyVisited.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentlyVisitedID", for: indexPath) as! TrendingCollectionViewCell
        let restaurant = recentlyVisited[indexPath.item]
        cell.backgroundColor = UIColor.white
        cell.addressLabel.text = restaurant.address
        cell.categoryLabel.text = restaurant.category
        cell.conditionLabel.text = restaurant.status
        cell.ratingLabel.text = String(restaurant.rating)
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

extension ProfileViewController: UICollectionViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRestaurant" {
            if let destVC = segue.destination as? RestaurantsViewController, let selectedRestaurant = sender as? Restaurants {
                destVC.selectedRestaurant = selectedRestaurant
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == recentlyVisitedCollectionView {
            let selectedRestaurant = recentlyVisited[indexPath.item]
            performSegue(withIdentifier: "goToRestaurant", sender: selectedRestaurant)
        }
    }
}
