//
//  Player.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import Foundation

enum PlayerState {
    case dealing, waitingForCall, stand, bust, blackjack
}

class Player {
    let name: String
    var hand = [Card]()
    var currentStatus = PlayerState.dealing

    init(name: String) {
        self.name = name
    }

    func reset() {
        hand = [Card]()
        currentStatus = PlayerState.dealing
    }

    func addCard(_ card: Card) {
        hand.append(card)
        if currentValue == 21 {
            currentStatus = .blackjack
        } else if currentValue > 21 {
            currentStatus = .bust
        } else if hand.count < 3 {
            currentStatus = .dealing
        } else {
            currentStatus = .waitingForCall
        }
    }

    var result: String {
        switch currentStatus {
        case .blackjack:
            return "Blackjack! (Score: 21)"
        case .bust:
            return "Bust! (Score: \(currentValue))"
        case .dealing, .waitingForCall, .stand:
            return "Score: \(currentValue)"
        }
    }

    var currentValue: Int {
        let sum = hand.reduce(0) { sum, card in
            if card.value == 1 {
                return sum
            }
            return sum + card.blackJackValue
        }
        var aces = hand.filter { $0.value == 1 }
        var sumWithAces = sum + 11 * aces.count
        while sumWithAces > 21 && aces.count > 0 {
            sumWithAces -= 10
            aces.remove(at: 0)
        }
        return sumWithAces
    }
}
