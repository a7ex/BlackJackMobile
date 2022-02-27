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
            if game.gameEnded {
                GameEndedView(game: game, cardSize: cardSize)
            } else {
                GameInProgressView(game: game, cardSize: cardSize)
            }
        }
        .tint(.white)
    }
}

struct BlackJackView_Previews: PreviewProvider {
    static var previews: some View {
        BlackJackView(game: BlackJack(playerNames: ["Alex"]))
    }
}
