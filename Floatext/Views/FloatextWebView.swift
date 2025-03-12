//
//  FloatextWebView.swift
//  Floatext
//
//  Created by José Vitor Alencar on 12/03/25.
//


import SwiftUI
import WebKit

struct FloatextWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        
        let kindleURL = URL(string: "https://read.amazon.com")!
        let request = URLRequest(url: kindleURL)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: FloatextWebView
        
        init(_ parent: FloatextWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let script = """
            document.body.style.backgroundColor = 'transparent';
            
            const elements = document.querySelectorAll('*');
            elements.forEach(el => {
                const style = window.getComputedStyle(el);
                if (style.backgroundColor === 'rgb(255, 255, 255)' || 
                    style.backgroundColor === '#ffffff' || 
                    style.backgroundColor === '#fff' || 
                    style.backgroundColor === 'white') {
                    el.style.backgroundColor = 'transparent';
                }
            });
            """
            
            webView.evaluateJavaScript(script)
        }
    }
}
