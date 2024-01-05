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

public protocol GoogleAppOpenAdFeatures: AnyObject {
    var viewModel: GoogleAppOpenAdViewModel { get }

    func setRootViewController(vc: UIViewController?)
    func requestAppOpenAd()
    func tryToPresentAd()
    
    static func makeFeatures() -> GoogleAppOpenAdFeatures
    
    func eraseToProvider() -> GoogleAppOpenAdProvider
    
}

public final class GoogleAppOpenAdProvider: NSObject, GoogleAppOpenAdFeatures {
    private var appOpenAd: GADAppOpenAd?
    private let timeoutInterval: TimeInterval = 4 * 3_600
    private var loadTime: Date?
    private var rootViewController: UIViewController?
    
    @ObservedObject public var viewModel: GoogleAppOpenAdViewModel = .init()
    
    private override init() {}
    
    public func setRootViewController(vc: UIViewController?) {
        self.rootViewController = vc
    }
    
    public func loadAppOpenAd() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            GADAppOpenAd.load(withAdUnitID: "ca-app-pub-3940256099942544/5575463023", request: GADRequest()) { [weak self] openAd, error in
                guard let `self` = self else { return }
                if let error {
                    self.appOpenAd = nil
                    self.loadTime = nil
                    self.viewModel.isLoadedAd = false
                    print("App open ad failed to load with error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
                
                self.appOpenAd = openAd
                self.appOpenAd?.fullScreenContentDelegate = self
                self.loadTime = Date()
                
                self.viewModel.isLoadedAd = true
                
                continuation.resume(returning: ())
            }
        }
    }
    
    public func requestAppOpenAd() {
        print("requestAppOpenAd")
        Task {
            do {
                guard self.rootViewController != nil else {
                    throw GAError.AppOpenAd.notFoundItem(.rootViewController)
                }
                
                try await self.loadAppOpenAd()
            } catch {
                print("error -> \(error)")
            }
        }

    }
    
    public func tryToPresentAd() {
        do {
            
            guard let appOpenAd else {
                throw GAError.AppOpenAd.notFoundItem(.ad)
            }
            
            guard let rootViewController else {
                throw GAError.AppOpenAd.notFoundItem(.rootViewController)
            }
            
            try appOpenAd.canPresent(fromRootViewController: rootViewController)
            
            appOpenAd.present(fromRootViewController: rootViewController)
            
        } catch {
            print("error -> \(error.localizedDescription)")
            requestAppOpenAd()
        }
    }
}

extension GoogleAppOpenAdProvider {
    
    private func wasLoadTimeLessThanNHoursAgo(timeoutInterval: TimeInterval) -> Bool {
        guard let loadTime else {
            return false
        }
        
        return Date().timeIntervalSince(loadTime) < timeoutInterval
    }
    
    public static func makeFeatures() -> GoogleAppOpenAdFeatures {
        return GoogleAppOpenAdProvider()
    }
    
    public func eraseToProvider() -> GoogleAppOpenAdProvider {
        return self
    }
}

extension GoogleAppOpenAdProvider: GADFullScreenContentDelegate {
    
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("error -> \(error)")
    }
    
    public func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adWillPresentFullScreenContent")
        viewModel.isShowingAd = true
    }
    
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidDismissFullScreenContent")
        appOpenAd = nil
        viewModel.isLoadedAd = false
        viewModel.isShowingAd = false
    }
    
    public func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adWillDismissFullScreenContent")
    }
}
