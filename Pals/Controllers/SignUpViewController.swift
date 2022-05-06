//
//  SignUpViewController.swift
//  Pals
//
//  Created by Apple  on 05/05/2022.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        if let email = emailLabel.text,
           let password = passwordLabel.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
              
                if let e = error {
                    self.errorLabel.text = e.localizedDescription
                } else {
                    // Register user and navigate to the Chat's view
                    self.performSegue(withIdentifier: "signUpToChats", sender: self)
                }
                
            }
            
        }
        
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        performSegue(withIdentifier: "signUpToSignIn", sender: self)
    }
}
