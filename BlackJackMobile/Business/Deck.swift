//
//  Deck.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import Foundation

protocol CardDeck {
    func pickCard() -> Card
}

class Deck: CardDeck {
    private let numberOfDecks = 6
    private var cards = [Card]()

    func pickCard() -> Card {
        if cards.count < 20 {
            shuffleCards()
        }
        return cards.remove(at: 0)
    }

    private var allCards: [Card] {
        return Suit.allCases.reduce([Card]()) { allCards, suit in
            return allCards + Array(repeating: suit.allCards, count: numberOfDecks).flatMap { $0 }
        }
    }

    private func shuffleCards() {
        cards = allCards.shuffled()
    }
}

private extension Suit {
    var allCards: [Card] {
        return Array(1...13).map { Card(value: $0, suit: self) }
    }
}
