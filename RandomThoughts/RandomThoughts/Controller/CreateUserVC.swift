//
//  CreateUserVC.swift
//  RandomThoughts
//
//  Created by David E Bratton on 11/12/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import Firebase

class CreateUserVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var createUserBtn: ButtonCornerRounding!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func presentAlert(alert:String) {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func createUserBtnPressed(_ sender: Any) {
        if emailTextField.text != "" || passwordTextField.text != "" || usernameTextField.text != "" {
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            guard let username = usernameTextField.text else { return }
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    debugPrint("Error creating user: \(error.localizedDescription)")
                } else {
                    let changeRequest = user?.user.createProfileChangeRequest()
                    changeRequest?.displayName = username
                    changeRequest?.commitChanges(completion: { (error) in
                        if let error = error {
                            debugPrint("Error: \(error.localizedDescription)")
                        }
                    })
                    
                    guard let userId = user?.user.uid else { return }
                    Firestore.firestore().collection(REF_USERS).document(userId).setData([
                        REF_USERNAME : username,
                        REF_DATE_USER_CREATED : FieldValue.serverTimestamp()
                        ], completion: { (error) in
                        
                            if let error = error {
                                debugPrint("Error: \(error.localizedDescription)")
                            } else {
                                self.navigationController?.popViewController(animated: true)
                            }
                    })
                }
            }
        } else {
            presentAlert(alert: "Email, password and username are all required!")
        }
    }
}
