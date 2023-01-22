//
//  ContentView.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 20.01.23.
//

import SwiftUI

struct ArticlesListView: View {
    @ObservedObject var viewModel = ArticlesListViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesListView()
    }
}
