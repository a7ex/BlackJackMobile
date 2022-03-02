//
//  CardImageView.swift
//  BJ3
//
//  Created by Alex da Franca on 27.02.22.
//

import SwiftUI

struct CardImageView: View {
    let cardImageName: String
    let maximumHeight: CGFloat
    
    var body: some View {
        Image(cardImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(6)
            .padding(4)
            .background(.white)
            .cornerRadius(6)
            .frame(maxHeight: maximumHeight)
            .shadow(color: .gray, radius: 3, x: 0, y: 0)
    }
}

struct CardImageView_Previews: PreviewProvider {
    static var previews: some View {
        CardImageView(cardImageName: "12h", maximumHeight: 160)
    }
}
