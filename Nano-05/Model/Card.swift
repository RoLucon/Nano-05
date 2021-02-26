//
//  Card.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 26/02/21.
//

import Foundation

struct Card:  Identifiable, Decodable {
    let id: Int
    
    let imageName: String
    let text: String
    let answer: String
}
