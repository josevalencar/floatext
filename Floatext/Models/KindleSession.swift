//
//  KindleSession.swift
//  Floatext
//
//  Created by José Vitor Alencar on 11/03/25.
//


import Foundation
import Combine
import WebKit

class KindleSession: ObservableObject {
    @Published var isLoggedIn = false
    @Published var username: String = ""
    
    private var cookies: [HTTPCookie] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Check for existing session
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        // Get cookies from WKWebsiteDataStore
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { [weak self] cookies in
            guard let self = self else { return }
            
            // Look for Amazon/Kindle session cookies
            let amazonCookies = cookies.filter { cookie in
                return cookie.domain.contains("amazon.com") && 
                      (cookie.name == "session-id" || cookie.name == "x-main")
            }
            
            self.cookies = amazonCookies
            
            // If we have the necessary cookies, consider the user logged in
            DispatchQueue.main.async {
                self.isLoggedIn = !amazonCookies.isEmpty
            }
        }
    }
    
    func clearSession() {
        // Clear cookies and website data
        let dataTypes = Set([WKWebsiteDataTypeCookies, WKWebsiteDataTypeLocalStorage])
        let date = Date(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: date) { [weak self] in
            DispatchQueue.main.async {
                self?.isLoggedIn = false
                self?.username = ""
            }
        }
    }
}
