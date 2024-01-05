//
//  GAError.swift
//  GoogleAdMobSwiftUI
//
//  Created by Gab on 2024/01/05.
//

import SwiftUI


public enum GAError: Error {
    
    public enum Item {
        case ad
        case rootViewController
    }
    
    public enum AppOpenAd: Error {
        case notFoundItem(GAError.Item)
    }
    
    public enum RewardAd: Error {
        
    }
    
    public enum BannerAd: Error {
        
    }
    
    public enum NativeAd: Error {
        
    }
    
}
