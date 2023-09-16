//
//  NameChangeViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 16.10.23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NameChangeViewController: UIViewController {

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var nameChangeField: DesignableUITextField!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameChangeField.layer.cornerRadius = 10
        nameChangeField.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        nameChangeField.layer.borderWidth = 1
        
        nameChangeField.attributedPlaceholder = NSAttributedString(string: "New Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    @IBAction func updateButtonAction(_ sender: Any) {
        if nameChangeField.text != ""{
            if let uid = Auth.auth().currentUser?.uid, let newName = nameChangeField.text {
                let user = ref.child("users").child(uid)
                user.updateChildValues(["name": newName]) { error, _ in
                    if let err = error {
                        let allert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                        allert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.navigationController?.present(allert, animated: true, completion: nil)
                    } else {
                        DispatchQueue.main.async {
                            self.nameChangeField.text = newName
                            NotificationCenter.default.post(name: Notification.Name("UserDataUpdated"), object: nil)
                        }
                        self.performSegue(withIdentifier: "goToProfile", sender: self)
                    }
                }
            }
        }
    }
}
