//
//  PaywallViewModel.swift
//  Spy
//
//  Created by Вячеслав on 12/1/23.
//

import SwiftUI
import StoreKit
import ApphudSDK

final class PaywallViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var isPurchasing: Bool = false
    
    @Published var products: [ApphudProduct] = []
    
    @Published var selected_product: ApphudProduct?
    
    @AppStorage("is_paidSubscription") var is_paidSubscription: Bool = false
    
    public func getPaywalls() {
        
        isLoading = true
        
//        Apphud.paywallsDidLoadCallback { (paywalls) in
//            
//            guard let paywall = paywalls.first(where: { $0.experimentName != nil }) else {
//                
//                if let convertedPaywalls = paywalls.first(where: {$0.isDefault}).flatMap({$0.products}) {
//                    
//                    self.products = convertedPaywalls
//                    self.selected_product = convertedPaywalls.first(where: {$0.productId == "noads.year"})
//                    
//                    self.isLoading = false
//                }
//                
//                print("no experiments")
//                
//                return
//            }
//            
//            print("yes experiments")
//            
//            self.products = paywall.products
//            self.selected_product = paywall.products.first(where: {$0.productId == "noads.year"})
//            
//            self.isLoading = false
//            
////            if let targetIsClose = paywall.json?["isClose"] as? Bool {
////                
////                self.isClose = targetIsClose
////            }
//        }
    }
    
    public func isSubscribed() -> Bool {
        
//        guard let subscriptions = async Apphud.subscriptions() else { return false }
//
//        if subscriptions.contains(where: {$0.isActive() == true}) {
//            
//            return true
//            
//        } else {
//            
//            return false
//        }
        
        return false
    }
    
    public func purchaseProduct() {
        
        isPurchasing = true
        
//        guard let product = selected_product else { return }
//        
//        Apphud.purchase(product, callback: { result in
//            
//            if result.success == true {
//                
//                withAnimation(.spring()) {
//                    
//                    self.is_paidSubscription = true
//                }
//                
//                self.isPurchasing = false
//                
//            } else if let error = result.error {
//                
//                print(error)
//                
//                self.isPurchasing = false
//            }
//        })
    }
    
    func restorePurchases() {
        
        isPurchasing = true
        
//        Apphud.restorePurchases(callback: { subscriptions, _, error in
//            
//            if let error = error {
//                
//                self.isPurchasing = false
//                
//                print(error)
//                
//            } else {
//                
//                guard let subscriptions = subscriptions else {
//                    
//                    self.isPurchasing = false
//                    
//                    return
//                }
//                
//                if subscriptions.contains(where: {$0.isActive() == true}) {
//                    
//                    self.isPurchasing = false
//                    
//                    withAnimation(.spring()) {
//                        
//                        self.is_paidSubscription = true
//                    }
//                }
//            }
//        })
    }
    
    func formattedPrice(for product: SKProduct) -> String {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        
        return formatter.string(from: product.price) ?? ""
    }
    
    func formattedSubscriptionPeriod(for product: SKProduct) -> String {
        
        guard let period = product.subscriptionPeriod else {
            
            return "nil"
        }
        
        var unit: String = ""
        
        switch period.unit {
        case .day:
            unit = period.numberOfUnits > 1 ? NSLocalizedString("days", comment: "") : NSLocalizedString("day", comment: "")
        case .week:
            unit = period.numberOfUnits > 1 ? NSLocalizedString("weeks", comment: "") : NSLocalizedString("week", comment: "")
        case .month:
            unit = period.numberOfUnits > 1 ? NSLocalizedString("months", comment: "") : NSLocalizedString("month", comment: "")
        case .year:
            unit = period.numberOfUnits > 1 ? NSLocalizedString("years", comment: "") : NSLocalizedString("year", comment: "")
        default:
            unit = "nil"
        }
        
        return "\(period.numberOfUnits) \(unit)"
    }
    
    func getTrialPeriod(for product: SKProduct) -> String? {
        
        if let period = product.introductoryPrice?.subscriptionPeriod {
            
            var unit = ""
            
            switch period.unit {
            case .day:
                unit = period.numberOfUnits == 1 ? NSLocalizedString("day", comment: "") : NSLocalizedString("days", comment: "")
            case .week:
                unit = period.numberOfUnits == 1 ? NSLocalizedString("week", comment: "") : NSLocalizedString("weeks", comment: "")
            case .month:
                unit = period.numberOfUnits == 1 ? NSLocalizedString("month", comment: "") : NSLocalizedString("months", comment: "")
            case .year:
                unit = period.numberOfUnits == 1 ? NSLocalizedString("year", comment: "") : NSLocalizedString("years", comment: "")
            default:
                unit = ""
            }
            
            return "Free trial for \(period.numberOfUnits) \(unit)"
        }
        
        return nil
    }
}
