//
//  Quote.swift
//  Oskorblyator
//
//  Created by Иван Маришин on 26.06.2021.
//

import Foundation

struct Quote: Decodable {
    let number: String
    let language: String
    let insult: String
    let created: String
    let shown: String
    let createdby: String
    let active: String
    let comment: String
}
