//
//  ChatModel.swift
//  Pals
//
//  Created by Apple on 10/05/2022.
//

import Foundation

struct Chat {
    let id: String
    let receptor: String
    let messages: [String]
    
    init(id: String, receptor: String, messages: [String]) {
        self.id = id
        self.receptor = receptor
        self.messages = messages
    }
}



