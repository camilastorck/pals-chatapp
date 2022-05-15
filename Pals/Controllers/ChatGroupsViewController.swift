//
//  ChatGroupsViewController.swift
//  Pals
//
//  Created by Apple on 05/05/2022.
//

import UIKit
import Contacts
import ContactsUI
import FirebaseFirestore

class ChatGroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CNContactPickerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let db = Firestore.firestore()
    var chats: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewChatButton))
        
        tableView.register(UINib(nibName: K.Tables.chatNibName, bundle: nil), forCellReuseIdentifier: K.Tables.chatCellId)

        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func loadChats() {
        
    }
    
    @objc func addNewChatButton(_ sender: UIBarButtonItem) {
        let vc = CNContactPickerViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let name = contact.givenName + " " + contact.familyName
        let newContact = Contact(name: name)
        let newChat = Chat(receptor: newContact, messages: [])
        chats.append(newChat)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Tables.chatCellId, for: indexPath) as! ChatCell
        cell.username.text = chats[indexPath.row].receptor.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentContact = chats[indexPath.row].receptor
        
        NotificationCenter.default.post(name: NSNotification.Name("Chat"), object: Chat(receptor: currentContact, messages: []))
        
        performSegue(withIdentifier: K.Segues.listToSingleChat, sender: self)
    }
    
}
