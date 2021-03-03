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
    
    var imageName: String?
    
    var info: [Info]
    
    var modal: String
    
    var link: String?
    var linkTitle: String?
    var linkHint: String?
    
    var redirect:[Redirect]?
}

struct Info: Decodable {
    
    var title: String
    var text: String

}

struct Redirect: Decodable {
    let title: String
    let hint: String
    let storyboard: String?
    let postId: Int?
}
