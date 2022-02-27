//
//  Deck.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import Foundation

class Deck {
    private var cards = [Card]()

    func pickCard() -> Card {
        if cards.count < 20 {
            shuffleCards()
        }
        return cards.remove(at: 0)
    }

    private var allCards: [Card] {
        return Suit.allCases.reduce([Card]()) { allCards, suit in
            return allCards + suit.allCards
        }
    }

    private func shuffleCards() {
        cards = allCards.shuffled()
    }
}

extension Suit {
    var allCards: [Card] {
        return Array(1...13).map { Card(value: $0, suit: self) }
    }
}
