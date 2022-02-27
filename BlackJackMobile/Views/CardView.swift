//
//  CardView.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import SwiftUI

struct CardView: View {
    let card: Card
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .frame(width: size * 0.6, height: size * 0.8)
            Text(card.symbol)
                .font(.system(size: size))
                .foregroundColor(card.suit.color)
                .offset(x: 0, y: size / -10.0)
                .padding(EdgeInsets(top: size * -0.18, leading: size * -0.06, bottom: size * -0.2, trailing: size * -0.06))
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(value: 12, suit: .hearts), size: 144)
    }
}
