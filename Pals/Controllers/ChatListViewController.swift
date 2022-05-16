//
//  ChatListViewController.swift
//  Pals
//
//  Created by Apple on 05/05/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatListViewController: UIViewController {
    
    let db = Firestore.firestore()
    var contactName: String?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newMessageField: UITextField!
    
    var messages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        title = contactName
        tableView.register(UINib(nibName: K.Tables.cellNibName, bundle: nil), forCellReuseIdentifier: K.Tables.cellId)
        loadMessages()
        
    }
    
    func loadMessages() {
        
        guard let contactReference = contactName else { return }
        
        db.collection(K.Firestore.collectionName).document(contactReference).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else { return }
            guard let data = document.data() else { return }
            
            self.messages = []
            
            if let messages = data[K.Firestore.messagesField] as? [String] {
                print(messages)
                DispatchQueue.main.async {
                    self.messages.append(contentsOf: messages)
                    self.tableView.reloadData()
                }
            }
              
        }
    }
    
    @IBAction func sendNewMessage(_ sender: UIButton) {
        
        guard let contactReference = contactName else { return }
        let contactRef = db.collection(K.Firestore.collectionName).document(contactReference)
        
        if let message = newMessageField.text {
            contactRef.updateData([
                K.Firestore.messagesField : FieldValue.arrayUnion([message])
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
        
        newMessageField.text = ""
    }
}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Tables.cellId, for: indexPath) as! MessageCell
        cell.messageLabel.text = messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
