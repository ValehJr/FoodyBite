//
//  HomeTabBarViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 20.09.23.
//

import UIKit

class HomeTabBarViewController: UITabBarController {
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x:0, y: self.tabBar.bounds.minY + 5 , width: self.tabBar.bounds.width, height: self.tabBar.bounds.height + 40), cornerRadius: (self.tabBar.frame.width/2)).cgPath
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = 25.0
        layer.shadowOpacity = 0.3
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor.white.cgColor
        
        self.tabBar.layer.insertSublayer(layer, at: 0)
        
        if let items = self.tabBar.items {
            for item in items {
                if screenSize.height < 700 {
                    item.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
                }
            }
        }
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
}
