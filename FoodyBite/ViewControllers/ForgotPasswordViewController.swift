//
//  ForgotPasswordViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 16.09.23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailImageHeight: NSLayoutConstraint!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var emailField: DesignableUITextField!
    @IBOutlet weak var forgotLabel: UILabel!
    
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
        
        self.view.addSubview(instructionLabel)
        self.view.addSubview(sendButton)
        self.view.addSubview(emailField)
        self.view.addSubview(forgotLabel)
        self.view.addSubview(emailImage)
        
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        emailField.layer.cornerRadius = 10
        
        let whiteBackButton = UIImage(named: "backButtonWhite")?.withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorImage = whiteBackButton
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = whiteBackButton
        
        hideKeyboardWhenTappedAround()
        
        if screenSize.height < 700 {
            emailImageHeight.constant = 24
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
    
    
    @IBAction func sendButtonAction(_ sender: Any) {
        if let email = emailField.text {
            Auth.auth().sendPasswordReset(withEmail: email){ [self] (error) in
                if let err = error {
                    let allert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    allert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(allert,animated: true)
                } else {
                    let allert = UIAlertController(title: "Success", message: "Reset email was sent, check your inbox!", preferredStyle: .alert)
                    allert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                        self.performSegue(withIdentifier: "goToLogin", sender: self)
                    })
                    self.present(allert,animated: true)
                }
            }
        }
    }
    
}
