//
//  ContentView.swift
//  GoogleAdMobSwiftUI
//
//  Created by Gab on 2024/01/04.
//

import SwiftUI

struct ContentView: View {
    @State private var openView: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear(perform: {
            GoogleAppOpenAdProvider.shared.requestAppOpenAd()
        })
        .onReceive(GoogleAppOpenAdProvider.shared.$loadingAd) { output in
            if output == true {
                GoogleAppOpenAdProvider.shared.tryToPresentAd()
            }
        }
        .fullScreenCover(isPresented: $openView, content: {
            EmptyView()
        })
        .onReceive(GoogleAppOpenAdProvider.shared.$dismissAd) { output in
            if output == true {
                openView = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
