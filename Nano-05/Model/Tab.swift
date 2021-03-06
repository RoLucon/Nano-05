//
//  Tabs.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 19/02/21.
//

import Foundation

struct Tab: Identifiable, Decodable {
    var id: Int
    var title: String
    var text: String
    var imageName:String?
    var listItens: [ListItens]
    var listTitle: String?
}

struct ListItens: Decodable {
    var title: String
    var idRef: Int
    var titleHint: String?
    var link: String?
}
