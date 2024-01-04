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
            ContentView()
                .onAppear {
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in print("didBecomeActiveNotification")
                    GoogleAppOpenAdProvider.shared.requestAppOpenAd()
                }
        }
        
    }
}
