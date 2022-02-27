//
//  Card.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import Foundation

struct Card {
    let suit: Suit
    let value: Int
    let symbol: String

    init(value: Int, suit: Suit) {
        self.suit = suit
        self.value = value
        let allCards = suit.allCards
        let index = allCards.index(allCards.startIndex, offsetBy: value - 1)
        symbol = String(allCards[index])
    }

    var imageName: String {
        return "\(value)\(suit.imageIdentifier)"
    }

    var blackJackValue: Int {
        return min(value, 10)
    }
}
