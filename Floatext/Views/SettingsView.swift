//
//  SettingsView.swift
//  Floatext
//
//  Created by José Vitor Alencar on 11/03/25.
//


import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @State private var opacity: Double = 0.9
    @State private var textSize: Double = 1.0
    let viewModel: WebViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.title)
                .fontWeight(.bold)
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("Background Opacity")
                Slider(value: $opacity, in: 0.5...1.0, step: 0.05)
                    .onChange(of: opacity) { oldValue, newValue in
                        viewModel.setOpacity(newValue)
                    }
            }
            .padding(.vertical)
            
            VStack(alignment: .leading) {
                Text("Text Size")
                Slider(value: $textSize, in: 0.8...1.5, step: 0.05)
                    .onChange(of: textSize) { oldValue, newValue in
                        viewModel.setTextSize(newValue)
                    }
            }
            .padding(.vertical)
            
            Button("Close") {
                isPresented = false
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding(30)
        .frame(width: 400)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .glassBackgroundEffect()
    }
}
