//
//  Constants.swift
//  Pals
//
//  Created by Apple  on 06/05/2022.
//

import Foundation

struct K {
    
    static let registerToChats = "signUpToChats"
    static let loginToChats = "signInToChats"
    static let listToSingleChat = "chatListToChat"
    static let cellId = "cell"
    static let nibName = "MessageCell"
    
    struct Firestore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
