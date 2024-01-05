//
//  GoogleAdMobSwiftUIApp.swift
//  GoogleAdMobSwiftUI
//
//  Created by Gab on 2024/01/04.
//

import SwiftUI
import GoogleMobileAds

@main
struct GoogleAdMobSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            GoogleAppOpenAdView()
                .onAppear {
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                }
        }
        
    }
}
