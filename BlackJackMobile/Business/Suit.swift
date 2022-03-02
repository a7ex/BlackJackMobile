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
}
