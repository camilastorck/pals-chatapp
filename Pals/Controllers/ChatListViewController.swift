//
//  ChatListViewController.swift
//  Pals
//
//  Created by Apple on 05/05/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var observer: NSObjectProtocol?
    
    let db = Firestore.firestore()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newMessageField: UITextField!
    @IBOutlet weak var contactNameLabel: UILabel!
    
    var messages: [Message] = [Message(sender: "Camila", content: "Hola, como estás?")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.Tables.cellNibName, bundle: nil), forCellReuseIdentifier: K.Tables.cellId)
        
        observer = NotificationCenter.default.addObserver(forName: NSNotification.Name("Chat"), object: nil, queue: .main, using: { notification in
            guard let object = notification.object as? Chat else { return }
            
            self.contactNameLabel.text = object.receptor.name
        })
        
        let rightBarButton = UIBarButtonItem(title: "Cerrar Sesión", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.myRightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        loadMessages()
    }
    
    func loadMessages() {
        
        db.collection(K.Firestore.collectionName).addSnapshotListener { querySnapshot, error in
            guard error == nil else { return }
            
            self.messages = []
            
            if let snapshotDoc = querySnapshot?.documents {
                for doc in snapshotDoc {
                    let data = doc.data()
                    if let messageSender = data[K.Firestore.senderField] as? String, let messageBody = data[K.Firestore.bodyField] as? String {
                        
                        let newMsg = Message(sender: messageSender, content: messageBody)
                        
                        DispatchQueue.main.async {
                            self.messages.append(newMsg)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Tables.cellId, for: indexPath) as! MessageCell
        cell.messageLabel.text = messages[indexPath.row].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


