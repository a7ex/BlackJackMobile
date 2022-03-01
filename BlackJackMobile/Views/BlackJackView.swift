//
//  BlackJackView.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import SwiftUI

struct BlackJackView: View {
    @ObservedObject var game: BlackJack
    private let cardSize = CGFloat(160)
    @State private var showHit = true
    @State private var scale: CGFloat = 4

    var body: some View {
        ZStack {
            Color.mint.ignoresSafeArea()
            VStack {
                Text("BlackJack")
                    .font(.largeTitle)
                    .padding(.bottom)
                Text("Dealer's hand:")
                    .font(.headline)
                ZStack {
                    HStack {
                        ForEach(game.dealerHand, id: \.value) { card in
                            CardImageView(cardImageName: (game.dealerHand.first == card || game.ended) ? card.imageName: "backside", maximumHeight: cardSize)
                        }
                    }
                    StatusLabelView(label: game.dealerStatus.text, textColor: game.dealerStatus.color)
                        .scaleEffect(scale)
                        .opacity(game.ended ? 1: 0)
                }
                Text("Score: \(game.dealerScore)")
                    .font(.caption)
                    .opacity(game.ended ? 1: 0)
                Text("Your hand:")
                    .font(.headline)
                    .padding(.top, 20)
                ScrollView {
                    Spacer()
                    ForEach(game.players) { player in
                        ZStack {
                            HStack {
                                Spacer()
                                ForEach(game.hand(of: player), id: \.imageName) { card in
                                    CardImageView(
                                        cardImageName: showCards(of: player) ? card.imageName: "backside",
                                        maximumHeight: cardSize
                                    )
                                }
                                Spacer()
                            }
                            StatusLabelView(label: game.status(of: player).text, textColor: game.status(of: player).color)
                                .scaleEffect(scale)
                                .opacity(game.ended ? 1: 0)
                        }
                        Text(player.result)
                            .font(.caption)
                            .opacity(showCards(of: player) ? 1: 0)
                    }
                }
                .background(.black.opacity(game.players.count > 1 ? 0.1: 0.0))
                .cornerRadius(12)
                Spacer()
                HStack {
                    if game.ended {
                        Button("New game", action: newGameButtonAction)
                            .buttonStyle(BorderedButtonStyle())
                    } else {
                        if showHit {
                            if game.canCurrentPlayerSplit {
                                Button("Split", action: splitButtonAction)
                                    .buttonStyle(BorderedButtonStyle())
                            }
                            Button("Hit", action: hitButtonAction)
                                .buttonStyle(BorderedButtonStyle())
                            Button("Stand", action: standButtonAction)
                                .buttonStyle(BorderedButtonStyle())
                        } else {
                            Button("Next", action: nextButtonAction)
                                .buttonStyle(BorderedButtonStyle())
                        }
                    }
                }
            }
            .padding()
        }
        .tint(.white)
        .navigationTitle("Play Blackjack")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Button actions

    private func newGameButtonAction() {
        game.startNewGame()
        scale = 3
    }

    private func showCards(of player: Player) -> Bool {
        return player == game.currentPlayer || game.ended
    }

    private func hitButtonAction() {
        withAnimation(.interpolatingSpring(mass: 0.05, stiffness: 10, damping: 0.9, initialVelocity: 5)) {
            game.hit()
            if game.players.count > 1 {
                showHit.toggle()
            } else {
                game.changeTurn()
            }
            scale = game.ended ? 1: 3
        }
    }
    
    private func splitButtonAction() {
        game.split()
    }

    private func standButtonAction() {
        withAnimation(.interpolatingSpring(mass: 0.05, stiffness: 10, damping: 0.9, initialVelocity: 5)) {
            game.stand()
            scale = game.ended ? 1: 3
        }
    }

    private func nextButtonAction() {
        withAnimation(.interpolatingSpring(mass: 0.05, stiffness: 10, damping: 0.9, initialVelocity: 5)) {
            game.changeTurn()
            showHit.toggle()
            scale = game.ended ? 1: 3
        }
    }
}

struct StatusLabelView: View {
    let label: String
    let textColor: Color

    var body: some View {
        Text(label)
            .font(.system(size: 60, weight: .black, design: .rounded))
            .rotationEffect(.degrees(Double.random(in: -16...16)))
            .foregroundColor(textColor)
            .shadow(color: .white, radius: 4, x: 0, y: 0)
            .shadow(color: .yellow, radius: 10, x: 0, y: 0)
    }
}

extension BlackJack {
    var dealerStatus: (text: String, color: Color) {
        return dealer.statusLabelString ?? (text: "", color: .green)
    }

    func status(of player: Player) -> (text: String, color: Color) {
        guard let status = player.statusLabelString else {
            if dealerScore > player.currentValue,
               dealer.currentStatus != .bust {
                return (text: "Lost", color: .red)
            } else {
                return (text: "Won!", color: .green)
            }
        }
        return status
    }
}

extension Player {
    var statusLabelString: (text: String, color: Color)? {
        switch currentStatus {
        case .blackjack:
            return (text: "Blackjack!", color: .green)
        case .bust:
            return (text: "Bust!", color: .red)
        case .dealing, .waitingForCall, .stand:
            return nil
        }
    }
}

struct BlackJackView_Previews: PreviewProvider {
    static var previews: some View {
        BlackJackView(game: BlackJack(playerNames: ["Alex"]))
    }
}
