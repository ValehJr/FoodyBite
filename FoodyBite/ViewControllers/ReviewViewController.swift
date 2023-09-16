//
//  ReviewViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 20.10.23.
//

import UIKit
import FirebaseDatabase

class ReviewViewController: UIViewController {
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var ratingStackView: StarRatingStackView!
    @IBOutlet weak var backgroundViewForStars: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    var restaurantID: String?

    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTextView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.cornerRadius = 10
        reviewTextView.isScrollEnabled = false
        reviewTextView.textContainer.lineBreakMode = .byWordWrapping
        reviewTextView.textContainer.maximumNumberOfLines = 0
        reviewTextView.textContainer.lineFragmentPadding = 0
        
        hideKeyboardWhenTappedAround()
    }
    
    
    
    @IBAction func doneButtonAction(_ sender: Any) {
        let newRating = ratingStackView.starsRating
        let newReviewText = reviewTextView.text
        let userID = UserData.shared.userID
        
        if let restaurantID = restaurantID {
            
            let restaurantsRef = Database.database().reference()
            
            let restaurantRef = restaurantsRef.child("restaurants").child(restaurantID)
            
            restaurantRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
                if var restaurant = currentData.value as? [String: Any] {
                    var numberOfRatings = restaurant["numberOfRatings"] as? Float ?? 0.0
                    var currentRating = restaurant["rating"] as? Float ?? 0.0
                    var reviews = restaurant["reviews"] as? [[String: Any]] ?? []
                    
                    numberOfRatings += 1
                    currentRating = (currentRating * (numberOfRatings - 1) + Float(newRating)) / numberOfRatings
                    
                    let newReview: [String: Any] = [
                        "userID": userID!,
                        "reviewText": newReviewText!,
                        "userRating": newRating
                    ]
                    
                    reviews.append(newReview)
                    
                    restaurant["numberOfRatings"] = numberOfRatings
                    restaurant["rating"] = currentRating
                    restaurant["reviews"] = reviews
                    
                    currentData.value = restaurant
                    
                    return TransactionResult.success(withValue: currentData)
                }
                return TransactionResult.success(withValue: currentData)
            }) { (error, committed, snapshot) in
                if let error = error {
                    print("Error updating restaurant data: \(error)")
                } else if !committed {
                    print("Transaction was not committed.")
                } else {
                    print("Restaurant data updated successfully.")
                }
            }
        }
    }
}
