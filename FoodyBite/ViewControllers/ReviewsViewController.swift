//
//  ReviewsViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 04.11.23.
//

import UIKit
import FirebaseDatabase

class ReviewsViewController: UIViewController {

    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    
    var ref = Database.database().reference()
    
    var reviewArray:[Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reviewsCollectionView.delegate = self
        reviewsCollectionView.dataSource = self
        
        reviewsCollectionView.backgroundColor = UIColor.white
        
        
    }
    
}
extension ReviewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        cell.backgroundColor = .white
        return cell
    }
}

extension ReviewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
