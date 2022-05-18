//
//  WelcomeViewController.swift
//  Pals
//
//  Created by Apple on 05/05/2022.
//

import UIKit
import Lottie

class WelcomeViewController: UIViewController {
    
    var animation: AnimationView?
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animation = .init(name: "welcome")
        animation?.loopMode = .loop
        animation?.frame = CGRect(x: 10, y: 60, width: 370, height: 370)
        view.addSubview(animation!)
        loginBtn.layer.cornerRadius = 10
        registerBtn.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        animation?.play()
    }
    
}
