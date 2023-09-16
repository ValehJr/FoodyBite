//
//  LoginViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 16.09.23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordImageHeight: NSLayoutConstraint!
    @IBOutlet weak var mailImageHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var mailImage: UIImageView!
    @IBOutlet weak var narrowLineView: UIView!
    @IBOutlet weak var appLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var passwordField: DesignableUITextField!
    @IBOutlet weak var emailField: DesignableUITextField!
    
    var window:UIWindow?
    
    let backgroundImage = UIImageView(image: UIImage(named: "loginImage"))
    
    let screenSize: CGRect = UIScreen.main.bounds
    
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
        self.view.addSubview(mailImage)
        self.view.addSubview(passwordImage)
        
        emailField.layer.cornerRadius = 10
        passwordField.layer.cornerRadius = 10
        loginButton.layer.cornerRadius = 10
        
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordField.autocorrectionType = .no
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        hideKeyboardWhenTappedAround()
        
        if screenSize.height < 700 {
            mailImageHeight.constant = 24
            passwordImageHeight.constant = 24
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            
        checkForUser()
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    
    @IBAction func forgotButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "forgotPassword", sender: self)
    }
    @IBAction func loginButtonAction(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [self] (result,error) in
                if let err = error {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                } else {
                    let uid = Auth.auth().currentUser?.uid
                    UserData.shared.userID = uid
                    emailField.text = ""
                    passwordField.text = ""
                    performSegue(withIdentifier: "goHome", sender: self)
                }
            }
        }
    }
    @IBAction func createAccountButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    func checkForUser() {
        if let user = Auth.auth().currentUser {
            UserData.shared.userID = user.uid
            performSegue(withIdentifier: "goHome", sender: self)
            print("User is logged in:",user)
        } else {
            print("User is not logged in")
        }
    }
    
}
