//
//  GameInProgressView.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import SwiftUI

struct GameInProgressView: View {
    @ObservedObject var game: BlackJack
    let cardSize: CGFloat
    @State private var revealed = false
    @State private var showHit = true

    var body: some View {
        VStack {
            Text("Dealer's hand:")
                .font(.headline)
            HStack {
                if let card = game.dealerHand.first {
                    CardImageView(cardImageName: card.imageName, maximumHeight: cardSize)
                }
                CardImageView(cardImageName: "backside", maximumHeight: cardSize)
            }
            if let player = game.currentPlayer {
                Text("Your hand:")
                    .font(.headline)
                    .padding(.top, 20)
                HStack {
                    ForEach(game.hand(of: player), id: \.imageName) { card in
                        CardImageView(
                            cardImageName: revealed ? card.imageName: "backside",
                            maximumHeight: cardSize
                        )
                    }
                }
                if revealed {
                    Text(player.result)
                }
            }
            Spacer()
            if revealed {
                HStack {
                    if showHit {
                        Button("Hit") {
                            game.hit()
                            if game.players.count > 1 {
                                showHit.toggle()
                            } else {
                                game.changeTurn()
                            }
                        }
                        .buttonStyle(BorderedButtonStyle())
                        Button("Stand") {
                            game.stand()
                            revealed.toggle()
                        }
                        .buttonStyle(BorderedButtonStyle())
                    } else {
                        Button("Next") {
                            game.changeTurn()
                            revealed.toggle()
                            showHit.toggle()
                        }
                        .buttonStyle(BorderedButtonStyle())
                    }
                }
            } else {
                Button("Reveal") {
                    withAnimation {
                        revealed.toggle()
                    }
                }
                .buttonStyle(BorderedButtonStyle())
            }
        }
        .padding()
    }
}

struct GameInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        GameInProgressView(game: BlackJack(playerNames: ["Alex"]), cardSize: 160)
    }
}
