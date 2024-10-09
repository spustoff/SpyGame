//
//  SettingsViewModel.swift
//  Spy
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    @AppStorage("is_rules") var is_rules: Bool = false
    @AppStorage("is_vibration") var is_vibration: Bool = false
    @AppStorage("is_paidSubscription") var is_paidSubscription: Bool = false
    
    @Published var isResetSets: Bool = false
    @Published var isPaywall: Bool = false
    @Published var isShare: Bool = false
}
