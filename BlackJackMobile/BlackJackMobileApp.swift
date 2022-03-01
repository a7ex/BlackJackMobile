//
//  BlackJackMobileApp.swift
//  BlackJackMobile
//
//  Created by Alex da Franca on 27.02.22.
//

import SwiftUI

@main
struct BlackJackMobileApp: App {
    var body: some Scene {
        WindowGroup {
            BlackJackView(game: BlackJack(playerNames: ["You"]))
        }
    }
}
