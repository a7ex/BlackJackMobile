//
//  DealerStatusBannerView.swift
//  BlackJackMobile
//
//  Created by Alex da Franca on 02.03.22.
//

import SwiftUI

struct DealerStatusBannerView: View {
    let label: String
    let textColor: Color

    var body: some View {
        Text(label)
            .font(.system(size: 20, weight: .black, design: .rounded))
            .foregroundColor(textColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(textColor, lineWidth: 4)
            )
    }
}

struct DealerStatusBannerView_Previews: PreviewProvider {
    static var previews: some View {
        DealerStatusBannerView(label: "Score: 10", textColor: .gray)
    }
}
