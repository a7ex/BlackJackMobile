//
//  ContentView.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import SwiftUI

struct ContentView: View {
    @State private var players = ["You"]
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    CardView(card: Card(value: 10, suit: .clubs), size: 300)
                        .rotationEffect(.degrees(-16))
                        .offset(x: -10, y: 0)
                    CardView(card: Card(value: 1, suit: .clubs), size: 300)
                        .rotationEffect(.degrees(8))
                        .offset(x: 30, y: 12)
                }
                Text("Players:")
                    .padding(.top)
                Text(players.joined(separator: ", "))
                NavigationLink(
                    destination: BlackJackView(game: BlackJack(playerNames: players))
                ) {
                    Text("Start Game")
                }
                .buttonStyle(BorderedButtonStyle())
                .padding()
                .tint(.white)
            }
            .navigationTitle("Blackjack")
            .background(Color.mint)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add player") {
                        players.append("Player \(players.count + 1)")
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
