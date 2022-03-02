//
//  Player.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import Foundation

enum PlayerState {
    case dealing, waitingForDecision, stand, bust, blackjack, won, lost
}

class Player: Identifiable, Equatable {
    let name: String
    private(set) var hand = [Card]()
    private(set) var currentStatus = PlayerState.dealing
    private var splitCount = 0

    init(name: String) {
        self.name = name
    }

    func reset() {
        hand = [Card]()
        splitCount = 0
        currentStatus = .dealing
    }

    func addCard(_ card: Card) {
        hand.append(card)
        if computeScore() == 21 {
            currentStatus = .blackjack
        } else if computeScore() > 21 {
            currentStatus = .bust
        } else if hand.count < 3 {
            currentStatus = .dealing
        } else {
            currentStatus = .waitingForDecision
        }
    }

    func stand() {
        currentStatus = .stand
    }

    func calculateWinner(dealerPoints: Int) {
        if [.blackjack, .bust].contains(currentStatus)  { return }
        currentStatus = dealerPoints > computeScore() ? .lost: .won
    }

    var result: String {
        return "Score: \(computeScore())"
    }

    func computeScore() -> Int {
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

    var canSplit: Bool {
        guard hand.count == 2,
              hand[0] == hand[1] else {
                  return false
              }
        return true
    }

    var nextSplitName: String {
        splitCount += 1
        return "\(name)-Split\(splitCount)"
    }

    func split() -> Card? {
        guard canSplit else {
            return nil
        }
        return hand.removeLast()
    }
}

// MARK: - Equatable

extension Player {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs === rhs
    }
}
