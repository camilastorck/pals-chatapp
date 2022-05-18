//
//  ChatGroupsViewController.swift
//  Pals
//
//  Created by Apple on 05/05/2022.
//

import UIKit
import FirebaseAuth
import Contacts
import ContactsUI
import FirebaseFirestore

class ChatGroupsViewController: UIViewController, CNContactPickerDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addChatBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    var contactNameDestination = ""
    
    let db = Firestore.firestore()
    var chats: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.Tables.chatNibName, bundle: nil), forCellReuseIdentifier: K.Tables.chatCellId)
        
        let rightBarButton = UIBarButtonItem(title: "Cerrar Sesión", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.signOutButton(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        addChatBtn.layer.cornerRadius = 30
        loadChats()
    }
    
    // MARK: - Actions
    
    @IBAction func addNewChat(_ sender: Any) {
        let vc = CNContactPickerViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    // Create new chat from contacts.
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let name = contact.givenName + " " + contact.familyName
        let contactRef = db.collection(K.Firestore.collectionName).document(name)
        
        contactRef.setData([
            K.Firestore.receptorField : name,
            K.Firestore.messagesField : []
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        tableView.reloadData()
    }
    
    func loadChats() {
        
        db.collection(K.Firestore.collectionName).addSnapshotListener { querySnapshot, error in
            if let e = error {
                print(e)
            }
            
            self.chats = []
            
            if let snapshotDoc = querySnapshot?.documents {
                for doc in snapshotDoc {
                    let data = doc.data()
                    if let messageReceptor = data[K.Firestore.receptorField] as? String, let messagesArray = data[K.Firestore.messagesField] as? [String] {
                        
                        let newChat = Chat(id: doc.documentID, receptor: messageReceptor, messages: messagesArray)
                        
                        DispatchQueue.main.async {
                            self.chats.append(newChat)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func signOutButton(_ sender:UIBarButtonItem!) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.listToSingleChat {
            let destinationVC = segue.destination as! ChatListViewController
            destinationVC.contactName = contactNameDestination
        }
    }
    
    private func deleteChat(indexPath: IndexPath) -> UIContextualAction {
        
        let chatName = chats[indexPath.row].receptor
        let chatRef = db.collection(K.Firestore.collectionName).document(chatName)
        
        let action = UIContextualAction(style: .destructive, title: "Borrar") { [ weak self ] _, _, _ in
            
            chatRef.delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            self?.chats.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            self?.tableView.reloadData()
        }
        return action
    }
    
}

extension ChatGroupsViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Tables.chatCellId, for: indexPath) as! ChatCell
        cell.username.text = chats[indexPath.row].receptor
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipe = UISwipeActionsConfiguration(actions: [deleteChat(indexPath: indexPath)])
        return swipe
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentContact = chats[indexPath.row].receptor
        contactNameDestination = currentContact
        performSegue(withIdentifier: K.Segues.listToSingleChat, sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}
