//
//  SwiftUIWebView.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 23.01.23.
//

import SwiftUI
import WebKit

// Getting warnings: "[Security] This method should not be called on the main thread as it may lead to UI unresponsiveness."
// It seems to be an Apple bug and nothing the developer can do about. Or must worry about.
// In any case, leaving this problem out of the scope of this small demo project.
// Discussion: https://developer.apple.com/forums/thread/712074?page=4
struct SwiftUIWebView: UIViewRepresentable {
    let webView: WKWebView
    
    init(url: URL) {
        webView = WKWebView(frame: .zero)
        webView.load(URLRequest(url: url))
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}
