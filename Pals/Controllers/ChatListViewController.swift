//
//  ChatListViewController.swift
//  Pals
//
//  Created by Apple  on 05/05/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatListViewController: UIViewController, UITableViewDataSource {

    let db = Firestore.firestore()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newMessageField: UITextField!
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.nibName, bundle: nil), forCellReuseIdentifier: K.cellId)
        
        navigationItem.hidesBackButton = true
        
        let rightBarButton = UIBarButtonItem(title: "Cerrar Sesión", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.myRightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @IBAction func sendNewMessage(_ sender: UIButton) {
        if let messageBody = newMessageField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.Firestore.collectionName).addDocument(data: [
                K.Firestore.senderField : messageSender,
                K.Firestore.bodyField : messageBody
            ]) { error in
                if let e = error {
                    print("Error saving data to Firestore: \(e)")
                } else {
                    print("Succesfully saved data.")
                }
            }
        }
    }
    
    @objc func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellId, for: indexPath) as! MessageCell
        cell.messageLabel.text = messages[indexPath.row].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


