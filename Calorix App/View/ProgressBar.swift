//
//  ProgressBar.swift
//  Calorix App
//
//  Created by Denis Krylov on 17/01/2023.
//

import SwiftUI

struct ProgressBar: View {
    
    @Binding var consumedCalories: CGFloat
    @State var caloriesGoal: String = ""
    @Binding var showAlert: Bool
    @State var totalCalories: CGFloat = 2000
    
    var width: CGFloat = UIScreen.main.bounds.size.width * 0.92
    var height: CGFloat = 20
    var color1 = Color(.systemOrange)
    var color2 = Color(.systemRed)
    
    var body: some View {
        let multiplier = width / 100
        let percent = getPercentage()
        VStack {
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
            HStack {
                Text("Eaten: \(Int(consumedCalories))")
                Spacer()
                Button {
                    showAlert.toggle()
                } label: {
                    Text("Change")
                }.alert("Change Goal", isPresented: $showAlert, actions: {
                    TextField("Calories", text: $caloriesGoal)
                    Button("Submit", action: {
                        totalCalories = CGFloat(Int(caloriesGoal) ?? 2000)
                        if totalCalories <= 500 {
                            totalCalories = 500
                        }
                    })
                    Button("Cancel", role: .cancel, action: {})
                }, message: {
                    Text("Please enter your new calories goal (minimum is 500).")
                })
                Spacer()
                Text("Goal: \(Int(totalCalories))")
            }
            .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        }
        .padding(.top, 16)
    }
    
    private func getPercentage() -> CGFloat {
        var percent = consumedCalories / totalCalories
        if percent < 0 {
            percent = 0
        } else if percent > 1 {
            percent = 1
        }
        return percent * 100
    }
}

//struct ProgressBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressBar(consumedCalories: Binding<CGFloat>)
//    }
//}
