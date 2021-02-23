//
//  Info.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 19/02/21.
//

import Foundation

struct Post: Identifiable, Decodable {
    var id: Int
    var title: String
    
    var info: [Info]
}

struct Info: Decodable {
    
    var title: String
    var text: String
    
    var link: String?
    var linkHint: String?
}
