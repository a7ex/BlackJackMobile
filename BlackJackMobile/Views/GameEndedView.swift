//
//  GameEndedView.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import SwiftUI

struct GameEndedView: View {
    @ObservedObject var game: BlackJack
    let cardSize: CGFloat

    var body: some View {
        VStack {
            Text("\(game.winner?.name ?? "Nobody") won!")
                .font(.largeTitle)
                .padding(.bottom)

            Text("Dealer's hand:")
            HStack {
                ForEach(game.dealerHand, id: \.value) { card in
                    CardImageView(cardImageName: card.imageName, size: cardSize)
                }
            }
            Text("Score: \(game.dealerScore)")

            ForEach(game.players, id: \.name) { player in
                Text("\(player.name)'s hand:")
                    .padding(.top)
                HStack {
                    ForEach(game.hand(of: player), id: \.value) { card in
                        CardImageView(cardImageName: card.imageName, size: cardSize)
                    }
                }
                Text(player.result)
            }
            Spacer()
            Button("New game") {
                game.startNewGame()
            }
            .buttonStyle(BorderedButtonStyle())
        }
    }
}

struct GameEndedView_Previews: PreviewProvider {
    static var previews: some View {
        GameEndedView(game: BlackJack(playerNames: ["Alex"]), cardSize: 160)
    }
}
