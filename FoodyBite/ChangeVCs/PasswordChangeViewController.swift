//
//  PasswordChangeViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 16.10.23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class PasswordChangeViewController: UIViewController {
    
    @IBOutlet weak var updatePasswordButton: UIButton!
    @IBOutlet weak var confirmPasswordField: DesignableUITextField!
    @IBOutlet weak var newPasswordField: DesignableUITextField!
    @IBOutlet weak var currentPasswordField: DesignableUITextField!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmPasswordField.layer.cornerRadius = 10
        confirmPasswordField.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        confirmPasswordField.layer.borderWidth = 1
        newPasswordField.layer.cornerRadius = 10
        newPasswordField.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        newPasswordField.layer.borderWidth = 1
        currentPasswordField.layer.cornerRadius = 10
        currentPasswordField.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        currentPasswordField.layer.borderWidth = 1
        
        newPasswordField.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        confirmPasswordField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        currentPasswordField.attributedPlaceholder = NSAttributedString(string: "Current Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    
    @IBAction func updatePasswordButtonAction(_ sender: Any) {
        if let currentPassword = currentPasswordField.text,
           let newPassword = newPasswordField.text,
           let confirmPassword = confirmPasswordField.text {
            if newPassword == confirmPassword {
                if let user = Auth.auth().currentUser {
                    let credential = EmailAuthProvider.credential(withEmail: user.email!, password: currentPassword)
                    user.reauthenticate(with: credential) { _, reauthError in
                        if let err = reauthError {
                            let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default))
                            self.navigationController?.present(alert, animated: true, completion: nil)
                        } else {
                            user.updatePassword(to: newPassword) { error in
                                if let err = error {
                                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                                    self.navigationController?.present(alert, animated: true, completion: nil)
                                } else {
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: "Success", message: "Password was changed successfully", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                                        self.navigationController?.present(alert, animated: true, completion: nil)
                                    }
                                    self.performSegue(withIdentifier: "goToProfile", sender: self)
                                }
                            }
                        }
                    }
                } else {
                    print("No user is currently signed in.")
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "New password and confirm password do not match", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
        }
    }

}
