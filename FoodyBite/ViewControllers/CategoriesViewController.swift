//
//  CategoriesViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 04.10.23.
//

import UIKit
import FirebaseDatabase

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var ref = Database.database().reference()
    
    let cellColors = [UIColor(red: 198/255, green: 61/255, blue: 47/255, alpha: 1),UIColor(red: 226/255, green: 94/255, blue: 62/255, alpha: 1),UIColor(red: 255/255, green: 155/255, blue: 80/255, alpha: 1),UIColor(red: 228/255, green: 133/255, blue: 134/255, alpha: 1),UIColor(red: 92/255, green: 75/255, blue: 153/255, alpha: 1),UIColor(red: 103/255, green: 65/255, blue: 136/255, alpha: 1),UIColor(red: 145/255, green: 109/255, blue: 179/255, alpha: 1),UIColor(red: 159/255, green: 145/255, blue: 204/255, alpha: 1)]
    
    var didSelectCategory: ((String,UIColor) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        categoryCollectionView.backgroundColor = UIColor.white
        
        self.view.backgroundColor = UIColor.white
        
        loadRestaurantDataFromFirebase()
    }
    
    var categories: [String] = []

    func loadRestaurantDataFromFirebase() {
        ref.child("restaurants").observeSingleEvent(of: .value) { (snapshot) in
            self.categories.removeAll()
            if let value = snapshot.value as? [String: Any] {
                for (_, restaurantData) in value {
                    if let restaurant = restaurantData as? [String: Any],
                       let _ = restaurant["name"] as? String,
                       let _ = restaurant["rating"] as? Float,
                       let _ = restaurant["address"] as? String,
                       let category = restaurant["category"] as? String,
                       let _ = restaurant["status"] as? String,
                       let _ = restaurant["numberOfRatings"] as? Float,
                       let reviewsData = restaurant["reviews"] as? [[String: Any]], !reviewsData.isEmpty {
                        if !self.categories.contains(category) {
                            self.categories.append(category)
                        }
                    } else {
                        print("Failed to unwrap values for a restaurant.")
                    }
                }
                self.categories.sort()
                self.categoryCollectionView.reloadData()
            }
        }
    }


    
}


extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryID", for: indexPath) as! CategoryCollectionViewCell
        cell.backgroundColor = UIColor.white
        let categoryName = categories[indexPath.item]
        cell.categoryView.layer.cornerRadius = 18
        cell.categoryLabel.text = categoryName
        let colorIndex = indexPath.item % cellColors.count
        cell.backgroundViewColor.backgroundColor = cellColors[colorIndex]
        return cell
        
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCategory" {
            if let destVC = segue.destination as? CategoryViewController, let selectedCategory = sender as? String{
                destVC.selectedCategory = selectedCategory
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedCategory = categories[indexPath.item]
        let colorIndex = indexPath.item % cellColors.count
        let selectedColor = cellColors[colorIndex]
        didSelectCategory?(selectedCategory, selectedColor)
        self.performSegue(withIdentifier: "goToCategory", sender: (selectedCategory))
    }
}
