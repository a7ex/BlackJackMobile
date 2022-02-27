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
    var winner: Player?
    let dealer: Player
    private let deck: Deck

    init(playerNames: [String]) {
        guard playerNames.count > 0 else {
            fatalError("Blackjack requires at least one player!")
        }
        deck = Deck()
        dealer = Player(name: "Dealer")
        players = playerNames.map { Player(name: $0) }
        startNewGame()
    }

    func startNewGame() {
        players.forEach { $0.reset() }
        dealer.reset()
        ended = false
        winner = nil
        dealCards()
    }

    func dealCards() {
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

    func playerScore(at index: Int? = nil) -> Int {
        guard let ind = index ?? currentPlayerIndex else {
            return 0
        }
        return players[ind].currentValue
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
        if player.currentStatus == .blackjack {
            endGame()
        }
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

    func endGame() {
        ended = true
        guard players.first(where: { $0.currentStatus == .dealing }) == nil else {
            winner = nil
            return
        }
        if let gameWinner = players.first(where: { $0.currentStatus == .blackjack }) {
            winner = gameWinner
            return
        }
        while dealer.currentValue < 17 {
            addCardToDealerHand()
        }
        let allPlayers = players + [dealer]
        let playersRanked = allPlayers
            .filter { $0.currentStatus != .bust }
            .sorted { $0.currentValue > $1.currentValue }
        winner = playersRanked.first
    }

    // MARK: - Private
    
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
