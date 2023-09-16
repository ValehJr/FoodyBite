//
//  SettingsViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 08.10.23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var fieldImage: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var termsConditionButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var changeNameButton: UIButton!
    @IBOutlet weak var changeLanguageButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeNameButton.titleLabel?.text = "Change Name"
        changeNameButton.titleLabel?.font = UIFont.init(name: "JosefinSans-SemiBold", size: 17)
        changePasswordButton.titleLabel?.font = UIFont.init(name: "JosefinSans-SemiBold", size: 17)
        changeLanguageButton.titleLabel?.font = UIFont.init(name: "JosefinSans-SemiBold", size: 17)
        changeEmailButton.titleLabel?.font = UIFont.init(name: "JosefinSans-SemiBold", size: 17)
        deleteAccountButton.titleLabel?.font = UIFont.init(name: "JosefinSans-SemiBold", size: 17)
        privacyPolicyButton.titleLabel?.font = UIFont.init(name: "JosefinSans-SemiBold", size: 17)
        termsConditionButton.titleLabel?.font = UIFont.init(name: "JosefinSans-SemiBold", size: 17)
        logoutButton.titleLabel?.font = UIFont.init(name: "JosefinSans-SemiBold", size: 17)
    }
    
    @IBAction func changePasswordButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "goToPassword", sender: self)
    }
    
    @IBAction func changeLanguageButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Language change", message: "The function is not available yet ;)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    @IBAction func changeNameButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "goToName", sender: self)
    }
    
    @IBAction func changeEmailButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "goToEmail", sender: self)
    }
    
    @IBAction func deleteAccountButtonAction(_ sender: Any) {
        let confirmAlert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account? This action is irreversible.", preferredStyle: .alert)
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        confirmAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            if let user = Auth.auth().currentUser {
                let uid = user.uid
                let userRef = Database.database().reference().child("users").child(uid)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "goToRegister", sender: self)
                    print("Gay")
                }
                userRef.removeValue { error, _ in
                    if let err = error {
                        let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true)
                    } else {
                        user.delete { error in
                            if let err = error {
                                let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                                self.present(alert, animated: true)
                            } else {
                                let alert = UIAlertController(title: "Success", message: "Account was deleted successfully", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                                self.present(alert, animated: true)
                            }
                        }
                    }
                }
            }
        }))
        self.present(confirmAlert, animated: true)
        print("Account deleted")
    }
    
    @IBAction func privacyPolicyButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func termsConditionButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        let curUser = Auth.auth()
        do {
            try curUser.signOut()
        }
        catch let err{
            let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
        self.performSegue(withIdentifier: "goToLogin", sender: self)
        
    }
}
