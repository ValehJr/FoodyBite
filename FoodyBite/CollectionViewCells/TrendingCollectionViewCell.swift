//
//  TrendingCollectionViewCell.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 22.09.23.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UIView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var trendingRestaurantsView: UIView!
    @IBOutlet weak var trendingCategoryView: UIView!
    @IBOutlet weak var trendingDistanceView: UIView!
    
    
    func bringCollectionViewToFront() {
        self.contentView.bringSubviewToFront(collectionView)
    }
}
