//
//  Card.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import Foundation

struct Card {
    let value: Int
    let suit: Suit

    var imageName: String {
        return "\(value)\(suit.imageIdentifier)"
    }

    var blackJackValue: Int {
        return min(value, 10)
    }
}
