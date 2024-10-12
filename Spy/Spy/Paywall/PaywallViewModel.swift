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
    
    // MARK: - Subscribe
    @Published var isLoading: Bool = false
    @Published var isPurchasing: Bool = false
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var products: [ApphudProduct] = []
    
    @Published var selected_product: ApphudProduct?
    
    @AppStorage("is_paidSubscription") var is_paidSubscription: Bool = false
    
    public func getPlacements() async {
        
        DispatchQueue.main.async {
            
            self.isLoading = true
        }
        
        await Apphud.fetchPlacements { (placements, error) in
            
            if let placement = placements.first(where: { $0.identifier == "main_placement" }), let paywall = placement.paywall  {
                
                let productsList = paywall.products
                Apphud.paywallShown(paywall)
                
                self.products = productsList
                self.selected_product = productsList.first(where: {$0.productId == "1year"})
                
                DispatchQueue.main.async {
                    
                    self.isLoading = false
                }
            }
        }
    }
    
    public func isSubscribed() async -> Bool {
        
        return Apphud.hasActiveSubscription()
    }
    
    public func purchaseProduct(completion: (() -> Void)? = nil) async {
        
        DispatchQueue.main.async {
            
            self.isPurchasing = true
        }
        
        guard let product = selected_product else { return }
        
        await Apphud.purchase(product, callback: { result in
            
            if let subscription = result.subscription, subscription.isActive() {
                // has active subscription
                DispatchQueue.main.async {
                    
                    withAnimation(.spring()) {
                        
                        self.is_paidSubscription = true
                    }
                    
                    self.isPurchasing = false
                }
                
                completion?()
                
            } else if let error = result.error {
                // Handle error
                DispatchQueue.main.async {
                    
                    self.isPurchasing = false
                    self.isError = true
                    self.errorMessage = error.localizedDescription
                    
                }
                
            } else {
                
                DispatchQueue.main.async {
                    self.isPurchasing = false
                    self.isError = true
                    self.errorMessage = NSLocalizedString("Subscription is not active.", comment: "")
                }
            }
            
            // Проверка на sandbox
            if self.isSandboxEnvironment() {
                
                DispatchQueue.main.async {
                    
                    self.isPurchasing = false
                    self.isError = true
                    self.errorMessage = NSLocalizedString("You are testing in the sandbox environment.", comment: "")
                }
            }
        })
    }
    
    func restorePurchases(completion: (() -> Void)? = nil) async {
        
        DispatchQueue.main.async {
            
            self.isPurchasing = true
        }
        
        await Apphud.restorePurchases(callback: { subscriptions, purchases, error in
            
            if let error = error {
                
                DispatchQueue.main.async {
                    
                    self.isPurchasing = false
                    self.isError = true
                    self.errorMessage = error.localizedDescription
                }
                
            } else {
                
                guard subscriptions != nil else {
                    
                    DispatchQueue.main.async {
                        
                        self.isPurchasing = false
                    }
                    
                    return
                }
                
                if Apphud.hasActiveSubscription(){
                    
                    DispatchQueue.main.async {
                        
                        self.isPurchasing = false
                    }
                    
                    withAnimation(.spring()) {
                        
                        self.is_paidSubscription = true
                    }
                    
                    completion?()
                    
                } else {
                    
                    DispatchQueue.main.async {
                        
                        self.isPurchasing = false
                        self.isError = true
                        self.errorMessage = NSLocalizedString("You don't have any subscription", comment: "")
                    }
                }
            }
        })
    }
    
    func formattedPrice(for product: SKProduct) -> String {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        
        return formatter.string(from: product.price) ?? ""
    }
    
    func formattedSubscriptionPeriod(for product: SKProduct) -> String {
        
        guard let subscriptionPeriod = product.subscriptionPeriod else {
            
            return "nil"
        }
        
        switch subscriptionPeriod.unit {
        case .day:
            return NSLocalizedString("1 \(NSLocalizedString("week", comment: ""))", comment: "Daily subscription period")
        case .week:
            return NSLocalizedString("1 \(NSLocalizedString("week", comment: ""))", comment: "Weekly subscription period")
        case .month:
            return NSLocalizedString("1 \(NSLocalizedString("month", comment: ""))", comment: "Monthly subscription period")
        case .year:
            return NSLocalizedString("1 \(NSLocalizedString("year", comment: ""))", comment: "Yearly subscription period")
        default:
            return "nil"
        }
    }
    
    func getTrialPeriod(for product: SKProduct) -> String? {
        
        if let period = product.introductoryPrice?.subscriptionPeriod {
            
            var unit = ""
            
            switch period.unit {
            case .day:
                unit = period.numberOfUnits == 1 ? NSLocalizedString("week", comment: "") : NSLocalizedString("weeks", comment: "")
            case .week:
                unit = period.numberOfUnits == 1 ? NSLocalizedString("week", comment: "") : NSLocalizedString("weeks", comment: "")
            case .month:
                unit = period.numberOfUnits == 1 ? NSLocalizedString("month", comment: "") : NSLocalizedString("months", comment: "")
            case .year:
                unit = period.numberOfUnits == 1 ? NSLocalizedString("year", comment: "") : NSLocalizedString("years", comment: "")
            default:
                unit = ""
            }
            
            return String(format: NSLocalizedString("Try %d %@ for free", comment: ""), period.numberOfUnits, unit)
        }
        
        return nil
    }
    
    private func isSandboxEnvironment() -> Bool {
        
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
            
            return false
        }
        
        return appStoreReceiptURL.lastPathComponent == "sandboxReceipt"
    }
    
    func formattedPrice(_ price: Double, product: SKProduct) -> String {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        
        return formatter.string(from: NSNumber(value: price)) ?? ""
    }
    
    func weeklyPrice(for product: SKProduct) -> String? {
        
        guard let subscriptionPeriod = product.subscriptionPeriod else {
            
            return nil
        }

        let price = product.price.doubleValue
        
        switch subscriptionPeriod.unit {
            
        case .day:
            return formattedPrice(price, product: product)
        case .week:
            return formattedPrice(price, product: product) // форматируем цену для отображения
        case .month:
            // Если подписка на месяц, делим на 4 недели
            let weeklyPrice = price / 4
            return formattedPrice(weeklyPrice, product: product) // форматируем цену для отображения
        case .year:
            // Если подписка на год, делим на 52 недели
            let weeklyPrice = price / 52
            return formattedPrice(weeklyPrice, product: product) // форматируем цену для отображения
        default:
            return nil
        }
    }
    
//    @Published var isLoading: Bool = false
//    @Published var isPurchasing: Bool = false
//    
//    @Published var products: [ApphudProduct] = []
//    
//    @Published var selected_product: ApphudProduct?
//    
//    @AppStorage("is_paidSubscription") var is_paidSubscription: Bool = false
//    
//    public func getPaywalls() {
//        
//        isLoading = true
//        
////        Apphud.paywallsDidLoadCallback { (paywalls) in
////            
////            guard let paywall = paywalls.first(where: { $0.experimentName != nil }) else {
////                
////                if let convertedPaywalls = paywalls.first(where: {$0.isDefault}).flatMap({$0.products}) {
////                    
////                    self.products = convertedPaywalls
////                    self.selected_product = convertedPaywalls.first(where: {$0.productId == "noads.year"})
////                    
////                    self.isLoading = false
////                }
////                
////                print("no experiments")
////                
////                return
////            }
////            
////            print("yes experiments")
////            
////            self.products = paywall.products
////            self.selected_product = paywall.products.first(where: {$0.productId == "noads.year"})
////            
////            self.isLoading = false
////            
//////            if let targetIsClose = paywall.json?["isClose"] as? Bool {
//////                
//////                self.isClose = targetIsClose
//////            }
////        }
//    }
//    
//    public func isSubscribed() -> Bool {
//        
////        guard let subscriptions = async Apphud.subscriptions() else { return false }
////
////        if subscriptions.contains(where: {$0.isActive() == true}) {
////            
////            return true
////            
////        } else {
////            
////            return false
////        }
//        
//        return false
//    }
//    
////    public func purchaseProduct() {
////        
////        isPurchasing = true
////        
//////        guard let product = selected_product else { return }
//////        
//////        Apphud.purchase(product, callback: { result in
//////            
//////            if result.success == true {paywall
//////
//////                withAnimation(.spring()) {
//////                    
//////                    self.is_paidSubscription = true
//////                }
//////                
//////                self.isPurchasing = false
//////                
//////            } else if let error = result.error {
//////                
//////                print(error)
//////                
//////                self.isPurchasing = false
//////            }
//////        })
////    }
//    
//    public func purchaseProduct(completion: (() -> Void)? = nil) async {
//        
//        DispatchQueue.main.async {
//            
//            self.isPurchasing = true
//        }
//        
//        guard let product = selected_product else { return }
//        
//        await Apphud.purchase(product, callback: { result in
//            
//            if let subscription = result.subscription, subscription.isActive() {
//                // has active subscription
//                DispatchQueue.main.async {
//                    
//                    withAnimation(.spring()) {
//                        
//                        self.is_paidSubscription = true
//                    }
//                    
//                    self.isPurchasing = false
//                }
//                
//                completion?()
//                
//            } else if let error = result.error {
//                // Handle error
//                DispatchQueue.main.async {
//                    
//                    self.isPurchasing = false
//                    self.isError = true
//                    self.errorMessage = error.localizedDescription
//                    
//                }
//                
//            } else {
//                
//                DispatchQueue.main.async {
//                    self.isPurchasing = false
//                    self.isError = true
//                    self.errorMessage = NSLocalizedString("Subscription is not active.", comment: "")
//                }
//            }
//            
//            // Проверка на sandbox
//            if self.isSandboxEnvironment() {
//                
//                DispatchQueue.main.async {
//                    
//                    self.isPurchasing = false
//                    self.isError = true
//                    self.errorMessage = NSLocalizedString("You are testing in the sandbox environment.", comment: "")
//                }
//            }
//        })
//    }
//    
//    func restorePurchases() {
//        
//        isPurchasing = true
//        
////        Apphud.restorePurchases(callback: { subscriptions, _, error in
////            
////            if let error = error {
////                
////                self.isPurchasing = false
////                
////                print(error)
////                
////            } else {
////                
////                guard let subscriptions = subscriptions else {
////                    
////                    self.isPurchasing = false
////                    
////                    return
////                }
////                
////                if subscriptions.contains(where: {$0.isActive() == true}) {
////                    
////                    self.isPurchasing = false
////                    
////                    withAnimation(.spring()) {
////                        
////                        self.is_paidSubscription = true
////                    }
////                }
////            }
////        })
//    }
//    
//    func formattedPrice(for product: SKProduct) -> String {
//        
//        let formatter = NumberFormatter()
//        
//        formatter.numberStyle = .currency
//        formatter.locale = product.priceLocale
//        
//        return formatter.string(from: product.price) ?? ""
//    }
//    
//    func formattedSubscriptionPeriod(for product: SKProduct) -> String {
//        
//        guard let period = product.subscriptionPeriod else {
//            
//            return "nil"
//        }
//        
//        var unit: String = ""
//        
//        switch period.unit {
//        case .day:
//            unit = period.numberOfUnits > 1 ? NSLocalizedString("days", comment: "") : NSLocalizedString("day", comment: "")
//        case .week:
//            unit = period.numberOfUnits > 1 ? NSLocalizedString("weeks", comment: "") : NSLocalizedString("week", comment: "")
//        case .month:
//            unit = period.numberOfUnits > 1 ? NSLocalizedString("months", comment: "") : NSLocalizedString("month", comment: "")
//        case .year:
//            unit = period.numberOfUnits > 1 ? NSLocalizedString("years", comment: "") : NSLocalizedString("year", comment: "")
//        default:
//            unit = "nil"
//        }
//        
//        return "\(period.numberOfUnits) \(unit)"
//    }
//    
//    func getTrialPeriod(for product: SKProduct) -> String? {
//        
//        if let period = product.introductoryPrice?.subscriptionPeriod {
//            
//            var unit = ""
//            
//            switch period.unit {
//            case .day:
//                unit = period.numberOfUnits == 1 ? NSLocalizedString("day", comment: "") : NSLocalizedString("days", comment: "")
//            case .week:
//                unit = period.numberOfUnits == 1 ? NSLocalizedString("week", comment: "") : NSLocalizedString("weeks", comment: "")
//            case .month:
//                unit = period.numberOfUnits == 1 ? NSLocalizedString("month", comment: "") : NSLocalizedString("months", comment: "")
//            case .year:
//                unit = period.numberOfUnits == 1 ? NSLocalizedString("year", comment: "") : NSLocalizedString("years", comment: "")
//            default:
//                unit = ""
//            }
//            
//            return "Free trial for \(period.numberOfUnits) \(unit)"
//        }
//        
//        return nil
//    }
}
