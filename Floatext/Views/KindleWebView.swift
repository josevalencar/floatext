//
//  KindleWebView.swift
//  Floatext
//
//  Created by José Vitor Alencar on 11/03/25.
//


import SwiftUI
import WebKit

struct KindleWebView: UIViewRepresentable {
    @Binding var isLoading: Bool
    let kindleSession: KindleSession
    let viewModel: WebViewModel
    private let kindleURL = URL(string: "https://read.amazon.com")!
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(
            forName: NotificationNames.reloadWebView,
            object: nil,
            queue: .main
        ) { _ in
            webView.reload()
        }
        
        NotificationCenter.default.addObserver(
            forName: NotificationNames.executeJavaScript,
            object: nil,
            queue: .main
        ) { notification in
            if let jsString = notification.userInfo?["js"] as? String {
                webView.evaluateJavaScript(jsString, completionHandler: nil)
            }
        }
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: kindleURL)
        webView.load(request)
        
        let cssString = viewModel.transparencyCSS
        
        let jsString = """
        var style = document.createElement('style');
        style.textContent = `\(cssString)`;
        document.head.appendChild(style);
        
        // Find elements with white background and make them transparent
        function makeWhiteTransparent() {
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
        }
        
        // Run initially and periodically to catch dynamically loaded content
        makeWhiteTransparent();
        setInterval(makeWhiteTransparent, 1000);
        """
        
        let script = WKUserScript(source: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(script)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: KindleWebView
        
        init(_ parent: KindleWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            
            parent.kindleSession.checkLoginStatus()
            
            webView.evaluateJavaScript(parent.viewModel.transparencyJS, completionHandler: nil)
        }
        
        func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            completionHandler(.performDefaultHandling, nil)
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url?.absoluteString, 
               url.contains("read.amazon.com") || url.contains("kindle.amazon.com") {
                parent.kindleSession.checkLoginStatus()
            }
            
            decisionHandler(.allow)
        }
    }
}
