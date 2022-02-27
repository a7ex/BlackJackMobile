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
        let position = Int.random(in: 0..<cards.count)
        let card = cards[position]
        cards.remove(at: position)
        return card
    }

    private var allCards: [Card] {
        var cards = [Card]()
        for suit in [Suit.clubs, Suit.spades, Suit.hearts, Suit.diamonds] {
            for value in 1...13 {
                cards.append(Card(value: value, suit: suit))
            }
        }
        return cards
    }

    private func shuffleCards() {
        cards = allCards.shuffled()
    }
}
