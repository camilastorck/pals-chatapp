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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        
        if let email = emailLabel.text,
           let password = passwordLabel.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
              
                if let e = error {
                    self.errorLabel.text = e.localizedDescription
                } else {
                    
                    // Sign In user
                    self.performSegue(withIdentifier: "signInToChats", sender: self)
                }
            }
            
        }
        
    }
   
    @IBAction func signUpButton(_ sender: UIButton) {
        performSegue(withIdentifier: "signInToSignUp", sender: self)
    }
    
}
