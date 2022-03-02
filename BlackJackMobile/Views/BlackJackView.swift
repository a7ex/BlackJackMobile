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
                    HStack(alignment: .bottom) {
                        Spacer()
                        ForEach(game.dealerHand) { card in
                            CardImageView(cardImageName: (game.dealerHand.first == card || game.ended) ? card.imageName: "backside", maximumHeight: cardSize)
                        }
                        Spacer()
                    }
                    DealerStatusBannerView(label: game.dealerStatus.text, textColor: game.dealerStatus.color)
                        .scaleEffect(game.ended ? scale: 1)
                        .opacity(game.ended ? 1: 0)
                }
                Divider()
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        Spacer()
                        ForEach(game.players) { player in
                            Group {
                                Text("\(player.name)'s hand:")
                                    .font(.headline)
                                    .padding(.top, 20)
                                ZStack {
                                    HStack {
                                        Spacer()
                                        ForEach(game.hand(of: player)) { card in
                                            CardImageView(
                                                cardImageName: showCards(of: player) ? card.imageName: "backside",
                                                maximumHeight: cardSize
                                            )
                                        }
                                        Spacer()
                                    }
                                    PlayerStatusBannerView(label: game.status(of: player).text, textColor: game.status(of: player).color)
                                        .scaleEffect(game.ended ? scale: 1)
                                        .opacity((game.ended || [.bust, .blackjack, .stand].contains(player.currentStatus)) ? 1: 0)
                                }
                                Text(player.result)
                                    .font(.caption)
                                    .opacity(showCards(of: player) ? 1: 0)

                            }
                            .id(game.players.firstIndex(of: player) ?? 0)
                        }
                        Spacer()
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
                                Button("Hit") {
                                    withAnimation(.interpolatingSpring(mass: 0.05, stiffness: 10, damping: 0.9, initialVelocity: 5)) {
                                        hitButtonAction()
                                        proxy.scrollTo(game.ended ? 0: (game.currentPlayerIndex ?? 0), anchor: .top)
                                        scale = game.ended ? 1: 3
                                    }
                                }
                                .buttonStyle(BorderedButtonStyle())
                                Button("Stand") {
                                    withAnimation(.interpolatingSpring(mass: 0.05, stiffness: 10, damping: 0.9, initialVelocity: 5)) {
                                        standButtonAction()
                                        proxy.scrollTo(game.ended ? 0: (game.currentPlayerIndex ?? 0), anchor: .top)
                                        scale = game.ended ? 1: 3
                                    }
                                }
                                .buttonStyle(BorderedButtonStyle())
                            } else {
                                Button("Next") {
                                    withAnimation(.interpolatingSpring(mass: 0.05, stiffness: 10, damping: 0.9, initialVelocity: 5)) {
                                        nextButtonAction()
                                        proxy.scrollTo(game.ended ? 0: (game.currentPlayerIndex ?? 0), anchor: .top)
                                        scale = game.ended ? 1: 3
                                    }
                                }
                                .buttonStyle(BorderedButtonStyle())
                            }
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
        game.hit()
        if game.players.count > 1 {
            showHit.toggle()
        } else {
            game.changeTurn()
        }
    }

    private func splitButtonAction() {
        game.split()
    }

    private func standButtonAction() {
        game.stand()
    }

    private func nextButtonAction() {
        game.changeTurn()
        showHit.toggle()
    }
}

extension BlackJack {
    var dealerStatus: (text: String, color: Color) {
        return dealer.statusLabelString ?? (text: dealer.result, color: Color.gray)
    }

    func status(of player: Player) -> (text: String, color: Color) {
        return player.statusLabelString ?? (text: "", color: .clear)
    }
}

extension Player {
    var statusLabelString: (text: String, color: Color)? {
        switch currentStatus {
        case .blackjack:
            return (text: "Blackjack!", color: .green)
        case .bust:
            return (text: "Bust!", color: .red)
        case .stand:
            return (text: "Stand", color: .gray)
        case .won:
            return (text: "Won!", color: .green)
        case .lost:
            return (text: "Lost", color: .red)
        case .dealing, .waitingForDecision:
            return nil
        }
    }
}

struct BlackJackView_Previews: PreviewProvider {
    static var previews: some View {
        let bj = BlackJack(playerNames: ["Alex"])
//        bj.hit()
//        bj.changeTurn()
//        bj.stand()
        return BlackJackView(game: bj)
    }
}
