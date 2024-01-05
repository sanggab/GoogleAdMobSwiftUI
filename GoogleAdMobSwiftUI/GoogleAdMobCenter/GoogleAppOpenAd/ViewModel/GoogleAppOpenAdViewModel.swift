//
//  GoogleAppOpenAdViewModel.swift
//  GoogleAdMobSwiftUI
//
//  Created by Gab on 2024/01/04.
//

import SwiftUI

public final class GoogleAppOpenAdViewModel: ObservableObject {
    @Published public var isLoadedAd: Bool = false
    @Published public var isShowingAd: Bool = false
}
