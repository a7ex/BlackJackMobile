//
//  PlayerStatusBannerView.swift
//  BlackJackMobile
//
//  Created by Alex da Franca on 02.03.22.
//

import SwiftUI

struct PlayerStatusBannerView: View {
    let label: String
    let textColor: Color

    var body: some View {
        Text(label)
            .font(.system(size: 60, weight: .black, design: .rounded))
            .foregroundColor(textColor)
            .shadow(color: .white, radius: 4, x: 0, y: 0)
            .shadow(color: .yellow, radius: 10, x: 0, y: 0)
    }
}

struct PlayerStatusBannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerStatusBannerView(label: "Blackjack!", textColor: .red)
    }
}
