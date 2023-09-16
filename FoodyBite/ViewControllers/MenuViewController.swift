//
//  MenuViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 04.11.23.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    var menuItems: [Menu] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        
        menuCollectionView.backgroundColor = UIColor.white
        
    }

}
extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuID", for: indexPath) as! MenuCollectionViewCell
        let menuItem = menuItems[indexPath.item]
        let imageName = "\(menuItem.itemName)"
        if let image = UIImage(named: imageName) {
            cell.menuImage.image = image
        }
        cell.collectionView.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        cell.collectionView.layer.borderWidth = 1
        cell.collectionView.layer.cornerRadius = 10
        cell.backgroundColor = .white
        return cell
    }
}

extension MenuViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
