//
//  MainView.swift
//  steps
//
//  Created by 重富 on 2023/01/13.
//

import SwiftUI

struct MainView: View {
//    @StateObject var stepsViewModel = StepsViewModel()
    
    var body: some View {
        TabView {
            StepsView()
                .tabItem {
                    Label("Step", systemImage: "figure.walk")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "slider.vertical.3")
                }
        }
        .tint(.green)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

