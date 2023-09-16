//
//  FriendsViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 04.10.23.
//

import UIKit

class FriendsViewController: UIViewController {

    @IBOutlet weak var friendsCollectionView: UICollectionView!
    
    let friendsImageNames = ["profile1","profile2","profile3","profile4","profile3","profile1","profile4","profile2","profile2","profile4","profile3","profile1","profile4","profile3","profile1","profile2","profile1","profile4","profile3","profile1","profile4","profile2","profile3","profile1","profile4","profile1","profile2","profile3","profile1","profile4","profile2","profile3","profile3","profile4","profile1","profile2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        friendsCollectionView.dataSource = self
        friendsCollectionView.delegate = self
    
        friendsCollectionView.backgroundColor = UIColor.white
        
        self.view.backgroundColor = UIColor.white
    }
}

extension FriendsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendsImageNames.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsID", for: indexPath) as! FriendsCollectionViewCell
        cell.backgroundColor = UIColor.white
        let imageName = friendsImageNames[indexPath.item]
        cell.profileImage.image = UIImage(named: imageName)
        cell.friendsView.layer.cornerRadius = cell.friendsView.frame.height / 2
        cell.friendsView.clipsToBounds = true
        return cell
    }
}

extension FriendsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
