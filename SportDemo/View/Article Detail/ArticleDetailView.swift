//
//  ArticleDetailView.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 23.01.23.
//

import SwiftUI

// No need for ViewModel here, as it's very simple.
struct ArticleDetailView: View {
    var url: URL

    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        SwiftUIWebView(url: url)
            .accessibility(identifier: AccessibilityIdentifiers.ArticleDetail.webView)
    }
}
