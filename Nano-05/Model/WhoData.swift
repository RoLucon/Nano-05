//
//  WhoData.swift
//  Nano-05
//
//  Created by Beatriz Sato on 28/02/21.
//

import Foundation

struct WhoData: Decodable {
    var TimeDim: Int
    var NumericValue: Double
}

struct Values: Decodable {
    var value: [WhoData]
}
