//
//  main.swift
//  BlackJackCLI
//
//  Created by Alex da Franca on 04.03.22.
//

import Foundation

let game = BlackJack(playerNames: ["Alex"])

var response = "y"
while response == "y" {
    print("Do you want to play a game of Blackjack? Type 'y' or 'n': ")
    response = readLine()?.lowercased() ?? ""
    if response != "y" {
        break
    }
    game.startNewGame()
    print(game.players[0].statusForCLI)
    print(game.dealer.dealerStatusForCLI)
    while !game.ended {
        print("Your turn player: \(game.currentPlayer?.name ?? ""). Type 'y' to get another card, type 'n' to pass: ")
        let response = readLine()?.lowercased() ?? ""
        if response == "y" {
            game.hit()
            game.changeTurn()
            if !game.ended,
               let player = game.currentPlayer {
                print(player.statusForCLI)
            }
        } else {
            game.stand()
        }
    }
    printFinalStatus()
    printFinalScores()
}

func printFinalStatus() {
    for player in game.players {
        print(player.finalStatusForCLI)
    }
    print(game.dealer.finalDealerStatusForCLI)
}

func printFinalScores() {
    let computerScore = game.computeDealerScore()
    let playerScore = game.players[0].computeScore()

    if game.dealer.hasBlackjack {
        print("Lose, dealer has Blackjack 😱")
    } else if game.players[0].hasBlackjack {
        print("You have a Blackjack! Congrats! You win! 😎")
    } else if playerScore > 21 {
        print("You went over. You lose 😤")
    } else if computerScore > 21 {
        print("Computer went over. You win 😁")
    } else if computerScore > playerScore {
        print("You lose 😤")
    } else if computerScore < playerScore {
        print("You win 😃")
    } else {
        print("Draw 🙃")
    }
}

extension Player {
    var hasBlackjack: Bool {
        return currentStatus == .blackjack
    }
    var statusForCLI: String {
        "Your cards: \(handForCLI), current score: \(computeScore())"
    }
    var finalStatusForCLI: String {
        "Your final hand: \(handForCLI), final score: \(computeScore())"
    }
    var dealerStatusForCLI: String {
        "Computer's first card: \(hand.first?.blackJackValue ?? 0)"
    }
    var finalDealerStatusForCLI: String {
        "Computer's final hand: \(handForCLI), final score: \(computeScore())"
    }
    private var handForCLI: String {
        return "\(hand.map({ $0.blackJackValue }))"
    }
}
