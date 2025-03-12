//
//  WebViewModel.swift
//  Floatext
//
//  Created by José Vitor Alencar on 11/03/25.
//


import Foundation
import Combine
import WebKit
import SwiftUI

class WebViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var showSettings = false
    @Published var showHelp = false
    @Published var firstLaunch = true
    
    let kindleSession: KindleSession
    
    init(kindleSession: KindleSession = KindleSession()) {
        self.kindleSession = kindleSession
    }
    
    var transparencyCSS: String {
        """
        /* Make backgrounds transparent */
        html, body {
            background-color: transparent !important;
            color: rgba(255, 255, 255, 0.9) !important;
        }
        
        /* Target all elements */
        * {
            background-color: transparent !important;
        }
        
        /* Target specific white backgrounds */
        [style*="background-color: white"],
        [style*="background-color: #fff"],
        [style*="background-color: #ffffff"],
        [style*="background: white"],
        [style*="background: #fff"],
        [style*="background: #ffffff"] {
            background-color: transparent !important;
            background: transparent !important;
        }
        
        /* Common white background classes */
        .white-bg, .bg-white {
            background-color: transparent !important;
        }
        
        /* Enhance text readability in transparent environment */
        p, div, span, h1, h2, h3, h4, h5, h6 {
            text-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
        }
        
        /* For Kindle reader specifically */
        #KindleReaderIFrame {
            background: transparent !important;
        }
        
        .kindleReader-container {
            background: transparent !important;
        }
        
        .kindleReader-book-content {
            background: transparent !important;
            color: rgba(255, 255, 255, 0.9) !important;
        }
        
        /* Kindle reader ui elements */
        .kindleReader-pageButton {
            background-color: rgba(80, 80, 80, 0.6) !important;
            border-radius: 50% !important;
        }
        
        /* Make white text more visible on transparent */
        [style*="color: white"],
        [style*="color: #fff"],
        [style*="color: #ffffff"] {
            color: rgba(230, 230, 230, 0.9) !important;
            text-shadow: 0 0 8px rgba(0, 0, 0, 0.5);
        }
        """
    }
    
    var transparencyJS: String {
        """
        // Function to make white backgrounds transparent
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
            
            // Special handling for Kindle reader iframe
            const kindleFrame = document.getElementById('KindleReaderIFrame');
            if (kindleFrame) {
                try {
                    const frameDoc = kindleFrame.contentDocument || kindleFrame.contentWindow.document;
                    if (frameDoc) {
                        const frameElements = frameDoc.querySelectorAll('*');
                        frameElements.forEach(el => {
                            const style = window.getComputedStyle(el);
                            if (style.backgroundColor === 'rgb(255, 255, 255)' || 
                                style.backgroundColor === '#ffffff' || 
                                style.backgroundColor === '#fff' || 
                                style.backgroundColor === 'white') {
                                el.style.backgroundColor = 'transparent';
                            }
                        });
                        
                        // Apply specific styles to the reader
                        const style = document.createElement('style');
                        style.textContent = `
                            body { background: transparent !important; }
                            .kindle-reader-page { background: transparent !important; }
                            .kindle-reader-content { color: rgba(255, 255, 255, 0.9) !important; }
                        `;
                        frameDoc.head.appendChild(style);
                    }
                } catch (e) {
                    console.log('Could not access iframe contents due to cross-origin policy');
                }
            }
        }
        
        // Run initially and periodically to catch dynamic content
        makeWhiteTransparent();
        setInterval(makeWhiteTransparent, 1000);
        
        // Optimize for visionOS
        document.body.style.fontSize = '1.1em';
        document.documentElement.style.colorScheme = 'dark';
        """
    }
    
    func reloadWebView() {
        NotificationCenter.default.post(name: NotificationNames.reloadWebView, object: nil)
    }
    
    func executeJavaScript(_ js: String) {
        NotificationCenter.default.post(
            name: NotificationNames.executeJavaScript, 
            object: nil, 
            userInfo: ["js": js]
        )
    }
    
    func setTextSize(_ size: Double) {
        let jsString = "document.body.style.fontSize = '\(size)em';"
        executeJavaScript(jsString)
    }
    
    func setOpacity(_ opacity: Double) {
        let jsString = "document.body.style.opacity = '\(opacity)';"
        executeJavaScript(jsString)
    }
    
    func showHelpOnFirstLaunch() {
        if firstLaunch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.showHelp = true
                self.firstLaunch = false
            }
        }
    }
}
