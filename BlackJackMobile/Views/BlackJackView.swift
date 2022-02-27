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

    var body: some View {
        ZStack {
            Color.mint.ignoresSafeArea()
            if game.ended {
                GameEndedView(game: game, cardSize: cardSize)
            } else {
                GameInProgressView(game: game, cardSize: cardSize)
            }
        }
        .tint(.white)
        .navigationTitle("Play Blackjack")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BlackJackView_Previews: PreviewProvider {
    static var previews: some View {
        BlackJackView(game: BlackJack(playerNames: ["Alex"]))
    }
}
