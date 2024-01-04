//
//  GoogleAppOpenAdProvider.swift
//  GoogleAdMobSwiftUI
//
//  Created by Gab on 2024/01/04.
//

import SwiftUI
import GoogleMobileAds

public extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.keyWindow

    }
}

public final class GoogleAppOpenAdProvider: NSObject, GADFullScreenContentDelegate {
    private var appOpenAd: GADAppOpenAd?
    private var loadTime = Date()
    private var viewController: UIViewController?
    
    @Published public var loadingAd: Bool = false
    @Published public var dismissAd: Bool = false
    
    public static let shared = GoogleAppOpenAdProvider()
    
//    public init(viewController: UIViewController) {
//        self.viewController = viewController
//    }
    
    func requestAppOpenAd() {
        print("requestAppOpenAd")
        self.appOpenAd = nil
        
        guard let root = UIApplication.shared.firstKeyWindow?.rootViewController else {
            return
        }
        
        self.viewController = root
        
        GADAppOpenAd.load(withAdUnitID: "ca-app-pub-3940256099942544/5575463023", request: GADRequest()) { [weak self] openAd, error in
            guard let `self` = self else { return }
            print("openAd -> \(openAd)")
            print("error -> \(error)")
            self.appOpenAd = openAd
            self.appOpenAd?.fullScreenContentDelegate = self
            self.loadTime = Date()
            
            self.loadingAd = true
        }
    }
    
    func tryToPresentAd() {
        
        if let appOpenAd, let viewController {
            appOpenAd.present(fromRootViewController: viewController)
        } else {
            requestAppOpenAd()
        }
    }
    
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("error -> \(error)")
    }
    
    public func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adWillPresentFullScreenContent")
    }
    
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidDismissFullScreenContent")
        dismissAd = true
    }
    
    public func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adWillDismissFullScreenContent")
    }
}
