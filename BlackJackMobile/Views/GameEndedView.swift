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
            Text("Dealer's hand:")
                .font(.headline)
            ZStack {
                HStack {
                    ForEach(game.dealerHand, id: \.value) { card in
                        CardImageView(cardImageName: card.imageName, maximumHeight: cardSize)
                    }
                }
                if let dealerStatus = game.dealerStatus {
                    StatusLabelView(label: dealerStatus.text, textColor: dealerStatus.color)
                }
            }
            Text("Score: \(game.dealerScore)")
            ScrollView {
                ForEach(game.players, id: \.name) { player in
                    Text("\(player.name)'s hand:")
                        .font(.headline)
                        .padding(.top)
                    ZStack {
                        HStack {
                            Spacer()
                            ForEach(game.hand(of: player), id: \.value) { card in
                                CardImageView(cardImageName: card.imageName, maximumHeight: cardSize)
                            }
                            Spacer()
                        }
                        if let playerStatus = game.status(of: player) {
                            StatusLabelView(label: playerStatus.text, textColor: playerStatus.color)
                        }
                    }
                    Text(player.result)
                }
            }
            .background(.black.opacity(0.1))
            .cornerRadius(12)
            Spacer()
            Button("New game") {
                game.startNewGame()
            }
            .buttonStyle(BorderedButtonStyle())
        }
        .padding()
    }
}

struct GameEndedView_Previews: PreviewProvider {
    static var previews: some View {
        GameEndedView(game: BlackJack(playerNames: ["Alex"]), cardSize: 160)
    }
}

struct StatusLabelView: View {
    let label: String
    let textColor: Color

    var body: some View {
        Text(label)
            .font(.system(size: 80, weight: .black, design: .rounded))
            .rotationEffect(.degrees(-16))
            .foregroundColor(textColor)
            .shadow(color: .white, radius: 4, x: 0, y: 0)
            .shadow(color: .yellow, radius: 10, x: 0, y: 0)
    }
}

extension BlackJack {
    var dealerStatus: (text: String, color: Color)? {
        return status(of: dealer)
    }

    func status(of player: Player) -> (text: String, color: Color)? {
        if winner?.name == player.name {
            return (text: "Won!", color: .green)
        }
        guard let status = player.statusLabelString else {
            return nil
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
