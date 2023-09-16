//
//  ForgotPasswordViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 16.09.23.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var emailField: DesignableUITextField!
    @IBOutlet weak var forgotLabel: UILabel!
    let backgroundImage = UIImageView(image: UIImage(named: "loginImage"))
    
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
        
        //Making the view darker
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
        self.view.addSubview(instructionLabel)
        self.view.addSubview(sendButton)
        self.view.addSubview(emailField)
        self.view.addSubview(forgotLabel)
        
        emailField.layer.cornerRadius = 10
    }
    
    
    
}
