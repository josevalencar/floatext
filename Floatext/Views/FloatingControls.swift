//
//  FloatingControls.swift
//  Floatext
//
//  Created by José Vitor Alencar on 11/03/25.
//


import SwiftUI
import RealityKit

struct FloatingControls: View {
    @ObservedObject var session: KindleSession
    @Binding var showSettings: Bool
    let viewModel: WebViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                // Reload the WebView
                viewModel.reloadWebView()
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 24))
            }
            .buttonStyle(.borderless)
            .padding(12)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            
            Button(action: {
                showSettings.toggle()
            }) {
                Image(systemName: "gear")
                    .font(.system(size: 24))
            }
            .buttonStyle(.borderless)
            .padding(12)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            
            if session.isLoggedIn {
                Button(action: {
                    session.clearSession()
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 24))
                }
                .buttonStyle(.borderless)
                .padding(12)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            }
        }
        .padding()
        .glassBackgroundEffect()
    }
}
