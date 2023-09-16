//
//  RegisterViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 16.09.23.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwordConfirmField: DesignableUITextField!
    @IBOutlet weak var passwordField: DesignableUITextField!
    @IBOutlet weak var emailField: DesignableUITextField!
    @IBOutlet weak var nameField: DesignableUITextField!
    
    let backgroundImage = UIImageView(image: UIImage(named: "registerImage"))
    
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

        self.view.addSubview(nameField)
        self.view.addSubview(loginButton)
        self.view.addSubview(passwordConfirmField)
        self.view.addSubview(passwordField)
        self.view.addSubview(emailField)
        self.view.addSubview(loginLabel)
        self.view.addSubview(registerButton)
        
        nameField.layer.cornerRadius = 10
        emailField.layer.cornerRadius = 10
        passwordField.layer.cornerRadius = 10
        passwordConfirmField.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    @IBAction func registerButtonAction(_ sender: Any) {
        
    }
    @IBAction func loginButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
}
