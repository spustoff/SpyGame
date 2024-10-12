//
//  OnBoardView.swift
//  SpyGame
//
//  Created by Александр Печинкин on 09.10.2024.
//

import SwiftUI
import StoreKit

struct OnBoardView: View {
    @State private var currentPage = 0
    @Binding var onBoardEnd: Bool
    var body: some View {
        ZStack {
            Color.bgPrime.ignoresSafeArea()
            
            VStack {
                OnBoardText(currentPage: currentPage)
                    .padding(.horizontal)
                    .layoutPriority(1)
                Spacer()
                OnBoardCards(currentPage: currentPage)
            }
            .padding(.top, 33)
            .edgesIgnoringSafeArea(.bottom)
            .padding(.bottom, UIScreen.main.bounds.height < 800 ? -104 : 0)
            
            button
        }
    }
    
    var button: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                ForEach(0..<4) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 8, height: 8)
                        .foregroundColor(currentPage == index ? .prime : .textWhite40)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            Button {
                withAnimation {
                    if currentPage < 3 {
                        currentPage += 1
                    } else {
                        SKStoreReviewController.requestReview()
                        onBoardEnd = true
                    }
                }
            } label: {
                PrimeButton(text: NSLocalizedString("Continue", comment: ""))
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 22)
    }
}

#Preview {
    OnBoardView(onBoardEnd: .constant(false))
}

struct OnBoardText: View {
    var currentPage: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Text(NSLocalizedString("An exciting game of 'Spy!'", comment: ""))
                    .modifier(Title1BoldTextModifier())
                Text(NSLocalizedString("Your task is to find the spy among the players using logic and observation", comment: ""))
                    .modifier(BodyTextModifier())
            }
            .offset(x: CGFloat((0 - currentPage )) * UIScreen.main.bounds.width)
            
            VStack(spacing: 0) {
                Text(NSLocalizedString("Hundreds of different locations!", comment: ""))
                    .modifier(Title1BoldTextModifier())
                Text(NSLocalizedString("Prove that you are a true master of intelligence", comment: ""))
                    .modifier(BodyTextModifier())
            }
            .offset(x: CGFloat((1 - currentPage )) * UIScreen.main.bounds.width)
            
            VStack(spacing: 0) {
                Text(NSLocalizedString("Flexible settings", comment: ""))
                    .modifier(Title1BoldTextModifier())
                Text(NSLocalizedString("Choose to make each batch unique and exciting", comment: ""))
                    .modifier(BodyTextModifier())
            }
            .offset(x: CGFloat((2 - currentPage )) * UIScreen.main.bounds.width)
            
            VStack(spacing: 0) {
                Text(NSLocalizedString("Your opinion is important!", comment: ""))
                    .modifier(Title1BoldTextModifier())
                Text(NSLocalizedString("Rate us on the AppStore, it will help make our game even better", comment: ""))
                    .modifier(BodyTextModifier())
            }
            .offset(x: CGFloat((3 - currentPage )) * UIScreen.main.bounds.width)
        }
    }
}

struct Title1BoldTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title.bold())
            .foregroundColor(Color.white)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.8)
    }
}

struct BodyTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.8)
            .foregroundColor(Color.textWhite80)
    }
}


struct OnBoardCards: View {
    var currentPage: Int
    
    var body: some View {
        ZStack(alignment: .bottom) {
            OnBoardIMG(img: "onboardingImg01")
                .offset(x: CGFloat((0 - currentPage )) * UIScreen.main.bounds.width)
            OnBoardIMG(img: "onboardingImg02")
                .offset(x: CGFloat((1 - currentPage )) * UIScreen.main.bounds.width)
            OnBoardIMG(img: "onboardingImg03")
                .offset(x: CGFloat((2 - currentPage )) * UIScreen.main.bounds.width)
            OnBoardIMG(img: "onboardingImg04")
                .offset(x: CGFloat((3 - currentPage )) * UIScreen.main.bounds.width)
        }
    }
}


struct OnBoardIMG: View {
    var img: String
    
    var body: some View {
        Image(img)
            .resizable()
            .aspectRatio(contentMode: .fit)
//            .frame(maxWidth: UIScreen.main.bounds.width / 1.38,
//                   maxHeight: UIScreen.main.bounds.height / 1.3)
    }
}
