//
//  Suit.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import Foundation
import SwiftUI

enum Suit: CaseIterable {
    case clubs, diamonds, hearts, spades

    var imageIdentifier: String {
        switch self {
        case .clubs:
            return "t"
        case .diamonds:
            return "k"
        case .hearts:
            return "h"
        case .spades:
            return "p"
        }
    }
    
    var allCardEmojis: String {
        switch self {
        case .clubs:
            return "🃑🃒🃓🃔🃕🃖🃗🃘🃙🃚🃛🃝🃞"
        case .diamonds:
            return "🃁🃂🃃🃄🃅🃆🃇🃈🃉🃊🃋🃍🃎"
        case .hearts:
            return "🂡🂢🂣🂤🂥🂦🂧🂨🂩🂪🂫🂭🂮"
        case .spades:
            return "🂡🂢🂣🂤🂥🂦🂧🂨🂩🂪🂫🂭🂮"
        }
    }

    var color: Color {
        switch self {
        case .hearts, .diamonds:
            return .red
        case .spades, .clubs:
            return .black
        }
    }

    var symbol: String {
        switch self {
        case .clubs:
            return "♣️"
        case .diamonds:
            return "♦️"
        case .hearts:
            return "♥️"
        case .spades:
            return "♠️"
        }
    }
}
