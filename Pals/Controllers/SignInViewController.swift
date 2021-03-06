//
//  SignInViewController.swift
//  Pals
//
//  Created by Apple  on 05/05/2022.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 10
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        
        if let email = emailLabel.text,
           let password = passwordLabel.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
              
                if let e = error {
                    self.errorLabel.text = e.localizedDescription
                } else {
                    
                    // Sign In user
                    self.performSegue(withIdentifier: K.Segues.loginToChats, sender: self)
                }
            }
            
        }
        
    }
   
    
}
