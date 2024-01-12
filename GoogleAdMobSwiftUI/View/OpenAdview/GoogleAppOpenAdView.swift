//
//  GoogleAppOpenAdView.swift
//  GoogleAdMobSwiftUI
//
//  Created by Gab on 2024/01/04.
//

import SwiftUI

public struct GoogleAppOpenAdView: View {
    @State private var openView: Bool = false
    @State private var mainVC: UIViewController?
    
    private let appOpenAdProivder = GoogleAppOpenAdProvider.makeFeatures()
    
    public var body: some View {

        Text("어디 한 번 불러보자")
            .appOpenAd(isPresented: $openView, rootViewController: $mainVC)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                self.mainVC = UIApplication.shared.firstKeyWindow?.rootViewController
            }
            .onTapGesture {
                openView = true
            }
        
        //        CustomOpenAdView {
        //            Text("hi Nice To meet You")
        //        }
        //        .requestLoadAppOpenAd(rootViewController: $mainVC)
        //        .isShowingAd { state in
        //            print("state -> \(state)")
        //        }
        //        .dismissOpenAd {
        //            print("dismissOpenAd")
        //        }
        //        .testView {
        //            Rectangle()
        //                .frame(width: 40, height: 40)
        //                .background(.red)
        //        }
    }
}

//struct GoogleAppOpenAdView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoogleAppOpenAdView()
//    }
//}
