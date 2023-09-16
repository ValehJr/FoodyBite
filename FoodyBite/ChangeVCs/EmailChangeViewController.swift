//
//  EmailChangeViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 16.10.23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class EmailChangeViewController: UIViewController {

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var changeEmailField: DesignableUITextField!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        changeEmailField.layer.cornerRadius = 10
        changeEmailField.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        changeEmailField.layer.borderWidth = 1
        
        changeEmailField.attributedPlaceholder = NSAttributedString(string: "New Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    @IBAction func updateButtonAction(_ sender: Any) {
        if changeEmailField.text != ""{
            if let uid = Auth.auth().currentUser?.uid, let newEmail = changeEmailField.text, isValidEmail(email: newEmail) {
                let user = ref.child("users").child(uid)
                user.updateChildValues(["email": newEmail]) { error, _ in
                    if let err = error {
                        let allert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                        allert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.navigationController?.present(allert, animated: true, completion: nil)
                    } else {
                        Auth.auth().currentUser?.updateEmail(to: newEmail)
                        DispatchQueue.main.async {
                            self.changeEmailField.text = newEmail
                            NotificationCenter.default.post(name: Notification.Name("UserDataUpdated"), object: nil)
                            self.changeEmailField.text = nil
                        }
                        self.changeEmailField.text = nil
                        self.performSegue(withIdentifier: "goToProfile", sender: self)
                    }
                    
                }
            } else {
                let alert = UIAlertController(title: "Invalid Email", message: "Please enter a valid email address", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
}
