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
    
    let db = Firestore.firestore()
    var contactName: String?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newMessageField: UITextField!
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        title = contactName
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.Tables.cellNibName, bundle: nil), forCellReuseIdentifier: K.Tables.cellId)
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


