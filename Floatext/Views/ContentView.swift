//
//  ContentView.swift
//  Floatext
//
//  Created by José Vitor Alencar on 11/03/25.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        FloatextWebView()
            .edgesIgnoringSafeArea(.all)
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
