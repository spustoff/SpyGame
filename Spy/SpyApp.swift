//
//  SpyApp.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI
import Firebase
import ApphudSDK
import Amplitude

class AppDelegate: NSObject, UIApplicationDelegate {
    
    @State var paywallModel = PaywallViewModel()
    @AppStorage("is_paidSubscription") var is_paidSubscription: Bool = false
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        Amplitude.instance().initializeApiKey("b42b8943c8c678134c1eb8c3260354a6")
        Apphud.start(apiKey: "app_HWhWMTWeF1Xx4UTGxVtyquJzUHZUJo")
        
        MySecureTransformer.register()
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        is_paidSubscription = paywallModel.isSubscribed()
    }
}

@main
struct SpyApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        
        WindowGroup {
            
            NavigationView(content: {
                
                ContentView()
            })
        }
    }
}
