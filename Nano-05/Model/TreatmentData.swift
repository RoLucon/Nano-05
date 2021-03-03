//
//  TreatmentData.swift
//  Nano-05
//
//  Created by Beatriz Sato on 01/03/21.
//

import Foundation

struct Treatments: Decodable {
    let resultset: [[ResultSet]]
}

enum ResultSet: Decodable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        
        throw DecodingError.typeMismatch(ResultSet.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Resultset"))
    }
    
    func toString() -> String {
        switch self {
        case .string(let x):
            return x
        default:
            return "0"
        }
    }
}
