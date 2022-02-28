//
//  BlackJack.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import Foundation
import Combine

class BlackJack: ObservableObject {
    @Published var ended = false
    @Published var currentPlayerIndex: Int?

    var players: [Player]
    let dealer: Player
    private let deck: CardDeck

    init(playerNames: [String],
         deck: CardDeck = Deck()) {
        guard playerNames.count > 0 else {
            fatalError("Blackjack requires at least one player!")
        }
        self.deck = deck
        dealer = Player(name: "Dealer")
        players = playerNames.map { Player(name: $0) }
        startNewGame()
    }

    func startNewGame() {
        players.forEach { $0.reset() }
        dealer.reset()
        ended = false
        dealCards()
    }

    var dealerHand: [Card] {
        return dealer.hand
    }

    var dealerScore: Int {
        return dealer.currentValue
    }

    var currentPlayer: Player? {
        guard let currentPlayerIndex = currentPlayerIndex else {
            return nil
        }
        return players[currentPlayerIndex]
    }

    func hand(of player: Player) -> [Card] {
        guard let position = position(of: player) else {
            return [Card]()
        }
        return hand(of: position)
    }

    func hit(index: Int? = nil) {
        guard !ended else { return }
        let validIndex = index ?? currentPlayerIndex
        guard let ind = validIndex else {
            return
        }
        currentPlayerIndex = ind
        let player = players[ind]
        player.addCard(deck.pickCard())
        objectWillChange.send()
    }

    func changeTurn() {
        guard !ended else { return }
        guard let ind = currentPlayerIndex else {
            return
        }
        if let next = nextPlayer(after: ind) {
            currentPlayerIndex = next
        } else {
            endGame()
        }
        objectWillChange.send()
    }

    func stand(index: Int? = nil) {
        guard let player = player(at: index) else {
            return
        }
        player.currentStatus = .stand
        if let index = position(of: player),
           let next = nextPlayer(after: index) {
            currentPlayerIndex = next
        } else {
            endGame()
        }
        objectWillChange.send()
    }

    // MARK: - Private

    private func dealCards() {
        for index in 0..<players.count {
            hit(index: index)
        }
        addCardToDealerHand()
        for index in 0..<players.count {
            hit(index: index)
        }
        addCardToDealerHand()
        currentPlayerIndex = 0
    }

    private func endGame() {
        guard players.first(where: { $0.currentStatus == .dealing }) == nil else {
            return
        }
        ended = true
        while dealer.currentValue < 17 {
            addCardToDealerHand()
        }
    }
    
    private func position(of player: Player) -> Int? {
        guard let position = players.firstIndex(where: { $0.name == player.name }) else {
            return nil
        }
        return position
    }

    private func hand(of player: Int) -> [Card] {
        return players[player].hand
    }

    private func addCardToDealerHand() {
        dealer.addCard(deck.pickCard())
        if dealer.currentStatus == .blackjack {
            endGame()
        }
    }

    private func player(at index: Int? = nil) -> Player? {
        guard !ended else { return nil }
        let validIndex = index ?? currentPlayerIndex
        guard let ind = validIndex else {
            return nil
        }
        return players[ind]
    }

    private func nextPlayer(after startIndex: Int) -> Int? {
        var current = (startIndex + 1) % players.count
        var status = players[current].currentStatus
        while ![.waitingForCall, .dealing].contains(status) {
            if current == startIndex {
                return nil
            }
            current = (current + 1) % players.count
            status = players[current].currentStatus
        }
        return current
    }
}
