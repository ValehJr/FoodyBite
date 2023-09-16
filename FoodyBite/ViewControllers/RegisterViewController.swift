//
//  RegisterViewController.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 16.09.23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var chooseImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var chooseImageView: UIView!
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var passwordImageHeight: NSLayoutConstraint!
    @IBOutlet weak var confirmImageHeight: NSLayoutConstraint!
    @IBOutlet weak var emailImageHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImageHeight: NSLayoutConstraint!
    @IBOutlet weak var confirmImage: UIImageView!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwordConfirmField: DesignableUITextField!
    @IBOutlet weak var passwordField: DesignableUITextField!
    @IBOutlet weak var emailField: DesignableUITextField!
    @IBOutlet weak var nameField: DesignableUITextField!
    

    
    let backgroundImage = UIImageView(image: UIImage(named: "registerImage"))
    
    let categoryNames = ["Mexican", "Italian", "Chinese", "Azerbaijani", "French", "Japanese", "Indian", "American"]
    
    var selectedImage: UIImage?
    
    var ref = Database.database().reference()
    
    var profileImageURL:String = ""

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
        self.view.addSubview(emailImage)
        self.view.addSubview(passwordImage)
        self.view.addSubview(confirmImage)
        self.view.addSubview(registerButton)
        self.view.addSubview(profileIcon)
        self.view.addSubview(chooseImageView)
        
        
        
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordConfirmField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        nameField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        
        nameField.layer.cornerRadius = 10
        emailField.layer.cornerRadius = 10
        passwordField.layer.cornerRadius = 10
        passwordConfirmField.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        hideKeyboardWhenTappedAround()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        if screenSize.height < 700 {
            emailImageHeight.constant = 24
            profileImageHeight.constant = 24
            passwordImageHeight.constant = 24
            confirmImageHeight.constant = 24
            chooseImageConstraint.constant = screenSize.width * 0.1
        } else {
            chooseImageConstraint.constant = screenSize.width * 0.3
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chooseImageView.layer.cornerRadius = chooseImageView.frame.height / 2
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text, let name = nameField.text, let passwordConfirm = passwordConfirmField.text {
            if password == passwordConfirm {
                if let selectedImage = selectedImage {
                    Auth.auth().createUser(withEmail: email, password: password) { [self] (result, error) in
                        if let err = error {
                            let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default))
                            self.present(alert, animated: true)
                        } else {
                            if let uid = Auth.auth().currentUser?.uid {
                                print("Uid:", uid)
                                UserData.shared.userID = uid
                                uploadProfileImage(selectedImage, uid: uid) { success, downloadURL in
                                    if success {
                                        self.ref.child("users").child(uid).setValue([
                                            "email": email, "name": name, "profileImageURL": downloadURL])
                                        self.performSegue(withIdentifier: "goToLocation", sender: self)
                                    } else {
                                        let alert = UIAlertController(title: "Error", message: "Failed to upload profile image", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                                        self.present(alert, animated: true)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "Alert", message: "Please select a profile image", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Password and Confirm password must be the same!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
                passwordConfirmField.text = ""
            }
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        print("go")
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    @IBAction func chooseImageAction(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
        print("Image")
    }
    func uploadProfileImage(_ image: UIImage, uid: String, completion: @escaping (Bool, String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(false, nil)
            return
        }
        let storageRef = Storage.storage().reference().child("profileImages").child("\(uid).jpg")
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(false, nil)
            } else {
                storageRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        completion(true, downloadURL.absoluteString)
                    } else {
                        print("Error obtaining download URL: \(error?.localizedDescription ?? "")")
                        completion(false, nil)
                    }
                }
            }
        }
    }
    
    @IBAction func unwindToRegister(segue: UIStoryboardSegue) {}
}



extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        profileImage.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


extension Categories {
    func toDictionary() -> [String: Any] {
        var categoryDict = [String: Any]()
        categoryDict["italian"] = italian.map { $0.toDictionary() }
        categoryDict["mexican"] = mexican.map { $0.toDictionary() }
        categoryDict["azerbaijani"] = azerbaijani.map { $0.toDictionary() }
        categoryDict["japanese"] = japanese.map { $0.toDictionary() }
        categoryDict["chinese"] = chinese.map { $0.toDictionary() }
        categoryDict["french"] = french.map { $0.toDictionary() }
        categoryDict["indian"] = indian.map { $0.toDictionary() }
        categoryDict["american"] = american.map { $0.toDictionary() }
        return categoryDict
    }
}

extension Restaurants {
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "rating": rating,
            "address": address,
            "category": category,
            "status": status
        ]
    }
}
