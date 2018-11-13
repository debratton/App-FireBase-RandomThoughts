//
//  LoginVC.swift
//  RandomThoughts
//
//  Created by David E Bratton on 11/12/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: ButtonCornerRounding!
    @IBOutlet weak var createUserBtn: ButtonCornerRounding!
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                self.navigateUser(place: "mainNav")
            }
        })
    }
    
    func navigateUser(place: String) {        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let whereToGo = storyboard.instantiateViewController(withIdentifier: place)
        present(whereToGo, animated: true, completion: nil)
    }
    
    func presentAlert(alert:String) {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                debugPrint("Error Logging into Firebase: \(error.localizedDescription)")
                self.presentAlert(alert: "Email or password is not correct!")
            } else {
                self.navigateUser(place: "mainNav")
            }
        }
    }
    
}
