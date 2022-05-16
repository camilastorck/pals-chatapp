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

class ChatGroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CNContactPickerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addChatBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    var contactNameDestination = ""
    
    let db = Firestore.firestore()
    var chats: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.Tables.chatNibName, bundle: nil), forCellReuseIdentifier: K.Tables.chatCellId)

        tableView.dataSource = self
        tableView.delegate = self
        
        let rightBarButton = UIBarButtonItem(title: "Cerrar Sesión", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.myRightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        addChatBtn.layer.cornerRadius = 30
    }
    
    @IBAction func addNewChat(_ sender: Any) {
        let vc = CNContactPickerViewController()
        vc.delegate = self
        present(vc, animated: true)
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
        
        let currentContact = chats[indexPath.row].receptor.name
        contactNameDestination = currentContact
        performSegue(withIdentifier: K.Segues.listToSingleChat, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.listToSingleChat {
            let destinationVC = segue.destination as! ChatListViewController
            destinationVC.contactName = contactNameDestination
        }
    }
    
}
