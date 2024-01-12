//
//  GoogleAppOpenAdModifier.swift
//  GoogleAdMobSwiftUI
//
//  Created by Gab on 2024/01/06.
//

import SwiftUI

public class GoogleAppOpenManager {
    
    static let shared = GoogleAppOpenManager()
    
    public var features: GoogleAppOpenAdFeatures = GoogleAppOpenAdProvider.makeFeatures()
}

public struct GoogleAppOpenModifier: ViewModifier {
    
    @Binding public var isPresented: Bool
    @Binding public var bindingVC: UIViewController?
//    public var vc: UIViewController?
    
    public init(isPresented: Binding<Bool>,
                bindingVC: Binding<UIViewController?>) {
        self._isPresented           = isPresented
        self._bindingVC              = bindingVC
    }
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { newValue in
                if newValue {
                    print("bindingVC -> \(bindingVC)")
                    GoogleAppOpenManager.shared.features.setRootViewController(vc: bindingVC)
                    GoogleAppOpenManager.shared.features.requestAppOpenAd()
                }
            }
            .onReceive(GoogleAppOpenManager.shared.features.viewModel.$isLoadedAd.filter({ $0 == true})) { _ in
                GoogleAppOpenManager.shared.features.tryToPresentAd()
            }
    }
}

public extension View {
    
    func appOpenAd(isPresented: Binding<Bool>, rootViewController: Binding<UIViewController?>) -> some View {
        modifier(GoogleAppOpenModifier(isPresented: isPresented, bindingVC: rootViewController))
    }
    
    func modal<ContentView: View>(isPresented: Binding<Bool>, @ViewBuilder View: () -> ContentView) -> some View {
        return self
    }
}
