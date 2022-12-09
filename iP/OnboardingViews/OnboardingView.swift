//
//  OnboardingView.swift
//  iP
//
//  Created by Andy Hoo on 12/9/22.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        TabView {
            PageView(
                title: "Welcome to iP!",
                subtitle: "We're glad to have you here.",
                imageName: "Intro",
                showsDismissButton: false,
                shouldShowOnboarding: $shouldShowOnboarding
            )
            
            PageView(
                title: "Locating...",
                subtitle: "We can find and map your IP Address in no time!",
                imageName: "Location",
                showsDismissButton: false,
                shouldShowOnboarding: $shouldShowOnboarding
            )
            
            PageView(
                title: "Basic Network Info",
                subtitle: "We also can give you your device's current basic network info!",
                imageName: "Info",
                showsDismissButton: true,
                shouldShowOnboarding: $shouldShowOnboarding
            )
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
