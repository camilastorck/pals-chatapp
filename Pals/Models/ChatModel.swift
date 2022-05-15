//
//  ChatModel.swift
//  Pals
//
//  Created by Apple on 10/05/2022.
//

import Foundation

struct Chat {
    let receptor: Contact
    let messages: [Message]
    
    init(receptor: Contact, messages: [Message]) {
        self.receptor = receptor
        self.messages = messages
    }
}

struct Contact {
    let name: String
}

struct Message {
    
    let sender: String
    let content: String
}
