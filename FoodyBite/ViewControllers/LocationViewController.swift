//
//  LocationViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 16.09.23.
//

import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var welcomeSeconLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    
    let backgroundImage = UIImageView(image: UIImage(named: "locationImage"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding image to the background
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(welcomeSeconLabel)
        self.view.addSubview(skipButton)
        self.view.addSubview(locationButton)
        self.view.addSubview(descriptionLabel)
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "goHome", sender: self)
    }
    @IBAction func locationButtonAction(_ sender: Any) {
    }
}
