//
//  ProgressBar.swift
//  Calorix App
//
//  Created by Denis Krylov on 17/01/2023.
//

import SwiftUI

struct ProgressBar: View {
    
    @State var percent: CGFloat
    var width: CGFloat = UIScreen.main.bounds.size.width * 0.92
    var height: CGFloat = 20
    var color1 = Color(.systemOrange)
    var color2 = Color(.systemRed)
    
    var body: some View {
        let multiplier = width / 100
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: height, style: .continuous)
                .frame(width: width, height: height)
                .foregroundColor(Color(UIColor.systemRed).opacity(0.1))
            
            RoundedRectangle(cornerRadius: height, style: .continuous)
                .frame(width: percent * multiplier, height: height)
                .background(LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .leading, endPoint: .trailing)
                    .clipShape(RoundedRectangle(cornerRadius: height, style: .continuous)))
                .foregroundColor(.clear)
        }
        .onAppear {
            fixPercentage()
        }
    }
    
    private func fixPercentage() {
        if percent < 0 {
            percent = 0
        } else if percent > 100 {
            percent = 100
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(percent: 50)
    }
}
