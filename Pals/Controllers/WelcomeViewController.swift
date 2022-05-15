//
//  WelcomeViewController.swift
//  Pals
//
//  Created by Apple  on 05/05/2022.
//

import UIKit
import Lottie

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginBtn.layer.cornerRadius = 10
        registerBtn.layer.cornerRadius = 10
    }
    
}
