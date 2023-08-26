//
//  CircularProgressView.swift
//  steps
//
//  Created by 重富 on 2023/01/09.
//

import SwiftUI

struct CircularProgressView: View {
    
    var step: CGFloat
    let maxStep: CGFloat
    let color: Color
    
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.1),
                lineWidth: 15)
            
            Circle()
                .trim(from: 0, to: step / maxStep)
                .stroke(color,
                        style: StrokeStyle(
                            lineWidth: 15,
                            lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.default, value: step)
        }
        
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(step: 1000, maxStep: 7000, color: Color.green)
    }
}

