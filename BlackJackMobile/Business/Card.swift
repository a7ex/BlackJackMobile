//
//  Card.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import Foundation

struct Card: Equatable, Identifiable {
    let id = UUID().uuidString
    let value: Int
    let suit: Suit

    var imageName: String {
        return "\(value)\(suit.imageIdentifier)"
    }

    var blackJackValue: Int {
        return min(value, 10)
    }
}

// MARK: - Equatable

extension Card {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.value == rhs.value
    }
}
