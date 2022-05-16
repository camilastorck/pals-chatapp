//
//  Constants.swift
//  Pals
//
//  Created by Apple  on 06/05/2022.
//

import Foundation

struct K {
    
    struct Segues {
        static let registerToChats = "signUpToChats"
        static let loginToChats = "signInToChats"
        static let listToSingleChat = "chatListToChat"
    }
    
    struct Tables {
        static let cellId = "cell"
        static let chatCellId = "chatCell"
        static let cellNibName = "MessageCell"
        static let chatNibName = "ChatCell"
    }
    
    struct Firestore {
        static let collectionName = "chats"
        static let receptorField = "receptor"
        static let messagesField = "messages"
        static let idField = "id"
    }
}
