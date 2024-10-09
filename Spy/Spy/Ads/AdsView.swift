//
//  AdsView.swift
//  Spy
//
//  Created by Вячеслав on 12/1/23.
//

//import SwiftUI
//import GoogleMobileAds

//struct AdsView: View {
//    
//    @StateObject var viewModel: MainViewModel
//    
//    @State var isLoading: Bool = true
//    
//    let type: AdsTypes
//    let isCloseButton: Bool
//    
//    var closeAction: () -> Void
//    
//    var body: some View {
//        
//        ZStack {
//            
//            if isLoading {
//                
//                Loader(width: 25, height: 25, color: .white)
//            }
//            
//            InterstitialAdView(isLoading: $isLoading, gameType: $viewModel.gameTypes)
//            
//            //                VStack {
//            //
//            //                    if isCloseButton {
//            //
//            //                        HStack {
//            //
//            //                            Spacer()
//            //
//            //                            Button(action: {
//            //
//            //                                closeAction()
//            //
//            //                            }, label: {
//            //
//            //                                Image(systemName: "xmark")
//            //                                    .foregroundColor(.white)
//            //                                    .font(.system(size: 14, weight: .bold))
//            //                                    .frame(width: 35, height: 35)
//            //                                    .background(Circle().fill(.black.opacity(0.4)))
//            //                            })
//            //                            .buttonStyle(ScaledButton(scaling: 0.9))
//            //                        }
//            //                    }
//            //
//            //                    if viewModel.isPaywallBanner {
//            //
//            //                        PaywallBanner(tapAction: {
//            //
//            //                            viewModel.isPaywall = true
//            //
//            //                        }, closeAction: {
//            //
//            //                            viewModel.isPaywallBanner = false
//            //
//            //                        })
//            //                            .frame(maxHeight: .infinity, alignment: .top)
//            //                    }
//            //
//            //                    Spacer()
//            //                }
//            //                    .padding()
//        }
//    }
//}
//
//enum AdsTypes {
//    
//    case banner, fullScreen
//}
//
//#Preview {
//    AdsView(viewModel: MainViewModel(), type: .fullScreen, isCloseButton: false, closeAction: {})
//}
//
//class InterstitialAdViewController: UIViewController, GADFullScreenContentDelegate {
//    
//    var isLoading: Binding<Bool>?
//    var gameType: Binding<GameTypes>?
//    private var interstitial: GADInterstitialAd?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let request = GADRequest()
//        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910",
//                               request: request) { [weak self] ad, error in
//
//            if let error = error {
//                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
//                return
//            }
//            print("loaded successfully")
//            self?.interstitial = ad
//            self?.interstitial?.fullScreenContentDelegate = self
//            self?.showAd()
//        }
//    }
//
//    func showAd() {
//        if let ad = interstitial {
//            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
//                ad.present(fromRootViewController: rootVC)
//                print("presented ad")
//            } else {
//                print("RootViewController not found")
//            }
//        } else {
//            print("Interstitial ad not loaded")
//        }
//    }
//    
//    /// Tells the delegate that the ad failed to present full screen content.
//    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        print("Ad did fail to present full screen content.")
//    }
//    
//    /// Tells the delegate that the ad will present full screen content.
//    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        isLoading?.wrappedValue = false
//        print("Ad will present full screen content.")
//    }
//    
//    /// Tells the delegate that the ad dismissed full screen content.
//    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        gameType?.wrappedValue = .cards
//        print("Ad did dismiss full screen content.")
//    }
//}
//
//struct InterstitialAdView: UIViewControllerRepresentable {
//    @Binding var isLoading: Bool
//    @Binding var gameType: GameTypes
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let controller = InterstitialAdViewController()
//        controller.isLoading = $isLoading
//        controller.gameType = $gameType
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//}
