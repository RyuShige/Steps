//
//  SettingsView.swift
//  steps
//
//  Created by 重富 on 2023/01/13.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("aimStep") var aimStep = 7000
    @State var aimStepDisplay = 7000
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Step Goal")
                    .font(.system(size: 40, weight: .bold))
                    .padding(.top, 40)
                Text("Set your daily step goal.")
                    .font(.title2)
                    .foregroundColor(.secondary)
                Spacer()
                HStack {
                    Button(action: {aimStepDisplay -= 500}) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .tint(.green)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                    }
                    
                    VStack {
                        Text("\(aimStepDisplay)")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 48, weight: .bold))
                    }
                    
                    Button(action: {aimStepDisplay += 500}) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .tint(.green)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                    }
                }
                
                Text("step/day")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    aimStep = aimStepDisplay
                    
                }) {
                    Text("change step goal")
                        .font(.title)
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 48)
                        .padding(.vertical, 12)
                        .background(
                            Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.5))
                        .cornerRadius(15)
                }
                .padding()
                .padding(.bottom, 20)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

