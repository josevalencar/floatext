//
//  HelpView.swift
//  Floatext
//
//  Created by José Vitor Alencar on 11/03/25.
//


import SwiftUI

struct HelpView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Floatext Help")
                .font(.title)
                .fontWeight(.bold)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Getting Started")
                    .font(.headline)
                
                Text("1. Sign in to your Amazon account when prompted")
                Text("2. Navigate to your Kindle library")
                Text("3. Select a book to start reading")
                Text("4. The white backgrounds will automatically be made transparent")
            }
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Controls")
                    .font(.headline)
                    .padding(.top, 10)
                
                HStack {
                    Image(systemName: "arrow.clockwise")
                        .frame(width: 30)
                    Text("Reload the current page")
                }
                
                HStack {
                    Image(systemName: "gear")
                        .frame(width: 30)
                    Text("Open settings to adjust opacity and text size")
                }
                
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .frame(width: 30)
                    Text("Sign out of your Amazon account")
                }
            }
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Tips")
                    .font(.headline)
                    .padding(.top, 10)
                
                Text("• For best results, use the Dark theme in Kindle settings")
                Text("• If text is hard to read, adjust the opacity in Settings")
                Text("• Turn pages by tapping or swiping the sides of the display")
                Text("• The app works best in well-lit environments")
            }
            
            Button("Close") {
                isPresented = false
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding(30)
        .frame(width: 500)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .glassBackgroundEffect()
    }
}
