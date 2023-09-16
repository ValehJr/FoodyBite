//
//  LoginViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 16.09.23.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var narrowLineView: UIView!
    @IBOutlet weak var appLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var passwordField: DesignableUITextField!
    @IBOutlet weak var emailField: DesignableUITextField!
    
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
        
        self.view.addSubview(createAccountButton)
        self.view.addSubview(loginButton)
        self.view.addSubview(forgotButton)
        self.view.addSubview(passwordField)
        self.view.addSubview(emailField)
        self.view.addSubview(appLabel)
        self.view.addSubview(narrowLineView)
        
        emailField.layer.cornerRadius = 10
        passwordField.layer.cornerRadius = 10
        loginButton.layer.cornerRadius = 10
    }
    
    @IBAction func forgotButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "forgotPassword", sender: self)
    }
    @IBAction func loginButtonAction(_ sender: Any) {
    }
    @IBAction func createAccountButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
}
