//
//  CustomOpenAdView.swift
//  GoogleAdMobSwiftUI
//
//  Created by Gab on 2024/01/04.
//

import SwiftUI

public struct CustomOpenAdView<ContentView: View>: View {
    
    private var content: () -> ContentView
    
    private var isShowingAds: ((Bool) -> Void)?
    private var dismissAdHandler: (() -> Void)?
    
    @Binding private var testVC: UIViewController?
    
    @State private var openViewTest: Bool = false
    
    private var rootViewController: UIViewController?
    
    private let appOpenAdProivder = GoogleAppOpenAdProvider.makeFeatures()
    
    public init(@ViewBuilder content: @escaping () -> ContentView) {
        self.content = content
        self._testVC = .constant(nil)
    }
    
    public var body: some View {
        content()
            .onReceive(appOpenAdProivder.viewModel.$isLoadedAd.dropFirst()) { output in
                if output {
                    appOpenAdProivder.tryToPresentAd()
                }
            }
            .onReceive(appOpenAdProivder.viewModel.$isShowingAd.dropFirst()) { output in
                if output {
                    isShowingAds?(true)
                } else {
                    isShowingAds?(false)
                    dismissAdHandler?()
                    openViewTest = true
                }
            }
            .onChange(of: testVC) { newValue in
                if let rootViewController = newValue {
                    appOpenAdProivder.setRootViewController(vc: rootViewController)
                    appOpenAdProivder.requestAppOpenAd()
                }
            }
    }
    
//    
//    public func setRootViewController(rootViewController: UIViewController?) -> Self {
//        var view = self
//        view.rootViewController = rootViewController
//        view.appOpenAdProivder.requestAppOpenAd()
//        return view
//    }
//    
//    public func requestLoadAppOpenAd(rootViewController: Binding<UIViewController?>) -> Self {
//        var view = self
//        view._testVC = rootViewController
//        return view
//    }
//    
//    public func loadedRequestAd() -> Self {
//        appOpenAdProivder.requestAppOpenAd()
//        return self
//    }
//    
//    public func isShowingAd(_ state: ((Bool) -> Void)?) -> Self {
//        var view = self
//        view.isShowingAds = state
//        return view
//    }
//    
//    public func dismissOpenAd(_ handler: (() -> Void)?) -> Self {
//        var view = self
//        view.dismissAdHandler = handler
//        return view
//    }

}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}
