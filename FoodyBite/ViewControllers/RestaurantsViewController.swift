//
//  RestaurantsViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 13.10.23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RestaurantsViewController: UIViewController {
    
    
    @IBOutlet weak var narrowView: UIView!
    @IBOutlet weak var rateExperienceButton: UIButton!
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var telephoneNumber: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    
    var selectedRestaurant: Restaurants?
    
    var ref = Database.database().reference()
    
    var userID:String?
    
    var keyValue:String?
    
    var reviewArray:[Review] = []
    
    let italianMenuItems = menuItems["Italian"]
    let mexicanMenuItems = menuItems["Mexican"]
    let chineseMenuItems = menuItems["Chinese"]
    let azerbaijaniMenuItems = menuItems["Azerbaijani"]
    let japaneseMenuItems = menuItems["Japanese"]
    let frenchMenuItems = menuItems["French"]
    let indianMenuItems = menuItems["Indian"]
    let americanMenuItems = menuItems["American"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let restaurant = selectedRestaurant {
            restaurantName.text = restaurant.name
            categoryLabel.text = restaurant.category
            addressLabel.text = restaurant.address
        }
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        
        reviewCollectionView.backgroundColor = UIColor.white
        menuCollectionView.backgroundColor = UIColor.white
        
        loadRestaurantDataFromFirebase()
        
        saveVisitedRestaurant(restaurantID: selectedRestaurant!.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadRestaurantDataFromFirebase()
    }
    
    @IBAction func rateExperienceAction(_ sender: Any) {
        self.performSegue(withIdentifier: "goToReview", sender: self)
    }
    
    @IBAction func seeAllPhotosButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "goToMenu", sender: self)
    }
    
    @IBAction func seeAllReviewsButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "goToReviews", sender: self)
    }
    @IBAction func telephoneButton(_ sender: Any) {
        let randomNumber = String(Int.random(in: 100_000_000...999_999_999))
        if let phoneURL = URL(string: "tel://\(randomNumber)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                print("Phone calls are not supported on this device.")
            }
        } else {
            print("Unable to generate a random phone number.")
        }
    }
    
    private func getMenuItemsForSelectedRestaurant() -> [Menu] {
        if let restaurantCategory = selectedRestaurant?.category {
            switch restaurantCategory {
            case "Italian":
                return italianMenuItems ?? []
            case "Mexican":
                return mexicanMenuItems ?? []
            case "Azerbaijani":
                return azerbaijaniMenuItems ?? []
            case "Japanese":
                return japaneseMenuItems ?? []
            case "Chinese":
                return chineseMenuItems ?? []
            case "American":
                return americanMenuItems ?? []
            case "Indian":
                return indianMenuItems ?? []
            case "French":
                return frenchMenuItems ?? []
            default:
                return []
            }
        }
        return []
    }
    
    @IBAction func unwindToRestaurant(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToReview" {
            if let destinationVC = segue.destination as? ReviewViewController {
                destinationVC.restaurantID = selectedRestaurant?.id
            }
        }
        if segue.identifier == "goToMenu" {
            if let destinationVC = segue.destination as? MenuViewController {
                destinationVC.menuItems = getMenuItemsForSelectedRestaurant()
            }
        }
        if segue.identifier == "goToReviews" {
            if let destinationVC = segue.destination as? ReviewsViewController {
                destinationVC.reviewArray = reviewArray
            }
        }
    }
    
    func loadRestaurantDataFromFirebase() {
        var reviews: [Review] = []
        
        if let restaurantID = self.selectedRestaurant?.id {
            ref.child("restaurants/\(restaurantID)/reviews").observe(.value) { snapshot in
                if let reviewsData = snapshot.value as? [[String: Any]] {
                    reviews = self.parseReviews(from: reviewsData)
                    self.reviewArray = reviews
                    self.reviewCollectionView.reloadData()
                }
            }
        }
    }
    
    func parseReviews(from data: [[String: Any]]) -> [Review] {
        var reviews: [Review] = []
        
        for (index, reviewData) in data.enumerated() {
            if index > 0,
               let userID = reviewData["userID"] as? String,
               let reviewText = reviewData["reviewText"] as? String,
               let userRating = reviewData["userRating"] as? Float {
                fetchUserInformation(userID: userID) { (userName, userProfilePictureURL) in
                    let review = Review(userID: userID, reviewText: reviewText, userRating: userRating, userName: userName, userProfilePictureURL: userProfilePictureURL!)
                    reviews.append(review)
                    self.reviewArray = reviews
                    self.reviewCollectionView.reloadData()
                }
            }
        }
        
        return reviews
    }
    
    func fetchUserInformation(userID: String, completion: @escaping (String, String?) -> Void) {
        let userRef = ref.child("users").child(userID)
        
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let userData = snapshot.value as? [String: Any] {
                if let userName = userData["name"] as? String,
                   let userProfilePictureURL = userData["profileImageURL"] as? String {
                    completion(userName, userProfilePictureURL)
                } else {
                    completion("", nil)
                }
            } else {
                completion("", nil)
            }
        }
    }
    
    func saveVisitedRestaurant(restaurantID: String) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            let userRef = ref.child("users").child(currentUserID)
            userRef.child("visitedRestaurants").childByAutoId().setValue(restaurantID)
        }
    }
    
}

extension RestaurantsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuCollectionView {
            return 3
        }
        if collectionView == reviewCollectionView {
            if reviewArray.count <= 4 {
                return reviewArray.count
            } else {
                return 4
            }
            
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuID", for: indexPath) as! MenuCollectionViewCell
            switch selectedRestaurant?.category{
            case "Italian":
                cell.backgroundColor = UIColor.white
                let menuItem = italianMenuItems![indexPath.item]
                let imageName = "\(menuItem.itemName)"
                if let image = UIImage(named: imageName) {
                    cell.menuImage.image = image
                }
                cell.collectionView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
                cell.collectionView.layer.borderWidth = 1
                cell.collectionView.layer.cornerRadius = 10
                return cell
            case "Mexican":
                cell.backgroundColor = UIColor.white
                let menuItem = mexicanMenuItems![indexPath.item]
                let imageName = "\(menuItem.itemName)"
                if let image = UIImage(named: imageName) {
                    cell.menuImage.image = image
                }
                cell.collectionView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
                cell.collectionView.layer.borderWidth = 1
                cell.collectionView.layer.cornerRadius = 10
                return cell
            case "Azerbaijani":
                cell.backgroundColor = UIColor.white
                let menuItem = azerbaijaniMenuItems![indexPath.item]
                let imageName = "\(menuItem.itemName)"
                if let image = UIImage(named: imageName) {
                    cell.menuImage.image = image
                }
                cell.collectionView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
                cell.collectionView.layer.borderWidth = 1
                cell.collectionView.layer.cornerRadius = 10
                return cell
            case "Japanese":
                cell.backgroundColor = UIColor.white
                let menuItem = japaneseMenuItems![indexPath.item]
                let imageName = "\(menuItem.itemName)"
                if let image = UIImage(named: imageName) {
                    cell.menuImage.image = image
                }
                cell.collectionView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
                cell.collectionView.layer.borderWidth = 1
                cell.collectionView.layer.cornerRadius = 10
                return cell
            case "Chinese":
                cell.backgroundColor = UIColor.white
                let menuItem = chineseMenuItems![indexPath.item]
                let imageName = "\(menuItem.itemName)"
                if let image = UIImage(named: imageName) {
                    cell.menuImage.image = image
                }
                cell.collectionView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
                cell.collectionView.layer.borderWidth = 1
                cell.collectionView.layer.cornerRadius = 10
                return cell
            case "American":
                cell.backgroundColor = UIColor.white
                let menuItem = americanMenuItems![indexPath.item]
                let imageName = "\(menuItem.itemName)"
                if let image = UIImage(named: imageName) {
                    cell.menuImage.image = image
                }
                cell.collectionView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
                cell.collectionView.layer.borderWidth = 1
                cell.collectionView.layer.cornerRadius = 10
                return cell
            case "Indian":
                cell.backgroundColor = UIColor.white
                let menuItem = indianMenuItems![indexPath.item]
                let imageName = "\(menuItem.itemName)"
                if let image = UIImage(named: imageName) {
                    cell.menuImage.image = image
                }
                cell.collectionView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
                cell.collectionView.layer.borderWidth = 1
                cell.collectionView.layer.cornerRadius = 10
                return cell
            case "French":
                cell.backgroundColor = UIColor.white
                let menuItem = frenchMenuItems![indexPath.item]
                let imageName = "\(menuItem.itemName)"
                if let image = UIImage(named: imageName) {
                    cell.menuImage.image = image
                }
                cell.collectionView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
                cell.collectionView.layer.borderWidth = 1
                cell.collectionView.layer.cornerRadius = 10
                return cell
            default:
                return cell
            }
            
        }
        if collectionView == reviewCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewsID", for: indexPath) as! ReviewsCollectionViewCell
            let review = reviewArray[indexPath.item]
            cell.backgroundColor = UIColor.white
            cell.nameLabel.text = review.userName
            cell.ratingLabel.text = String(format:"%.1f",(review.userRating))
            cell.reviewLabel.text = review.reviewText
            let profileImageURL = review.userProfilePictureURL
            let imageURL = URL(string: profileImageURL)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL!) {
                    DispatchQueue.main.async {
                        cell.profileImage.image = UIImage(data: data)
                        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
                    }
                }
            }
            cell.collectionView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
            cell.collectionView.layer.borderWidth = 1
            cell.collectionView.layer.cornerRadius = 10
            return cell
        }
        return UICollectionViewCell()
    }
}

extension RestaurantsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
