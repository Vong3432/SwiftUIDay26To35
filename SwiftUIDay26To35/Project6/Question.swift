//
//  Question.swift
//  SwiftUIDay26To35
//
//  Created by Vong Nyuksoon on 24/12/2021.
//

import Foundation

struct Question: Identifiable {
    let id = UUID().uuidString
    var question: String
    var answer: Int
}
