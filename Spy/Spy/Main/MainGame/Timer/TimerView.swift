//
//  TimerView.swift
//  Spy
//
//  Created by Вячеслав on 11/19/23.
//

import SwiftUI

struct TimerView: View {
    
    @StateObject var viewModel: MainViewModel
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    @State private var counterVibro = 0
    
    var body: some View {
        
        ZStack {
            
//            Color.bgPrime
            LinearGradient(colors: [Color.bgGameTopTrailGrad, Color.bgGameBotLeadGrad], startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()
            
            VStack {
                
                VStack(spacing: 30) {
                    
                    VStack(spacing: 10) {
                        
                        if viewModel.timeRemaining == viewModel.totalTime, let asker = viewModel.selectedAsker {
                            
                            HStack {
                                
                                Image(asker.playerPhoto)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 45)
                                
                                Text("\(asker.playerName), ")
                                    .foregroundColor(Color("bezhev"))
                                    .font(.system(size: 34, weight: .semibold)) +
                                
                                Text("asks first")
                                    .foregroundColor(.white)
                                    .font(.system(size: 34, weight: .semibold))
                            }
                            
                        } else {
                            
                            Text("Question time")
                                .foregroundColor(Color.second)
                                .font(.system(size: 40, weight: .semibold))
                        }
                        
                        Text(viewModel.timeRemaining == viewModel.totalTime ? "Press play when all players are ready to start the timer" : "Press pause at any time to arrange a vote or for a spy to choose a location")
                            .foregroundColor(.white)
                            .font(.system(size: 17, weight: .medium))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    
                    ZStack {
                        
                        Circle()
                            .trim(from: 0, to: 0.75)
                            .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                            .rotationEffect(Angle(degrees: 135))
                            .foregroundColor(Color.bgButton)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(viewModel.timeRemaining) / CGFloat(viewModel.totalTime) * 0.75)
                            .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                            .foregroundColor(Color.prime)
                            .rotationEffect(Angle(degrees: 135))
                            .animation(.linear(duration: 0.2), value: viewModel.timeRemaining)
                        
                        Text(timeString(time: viewModel.timeRemaining))
                            .foregroundColor(viewModel.timeRemaining > 10 ? Color.textWhite : (viewModel.timeRemaining > 5 ? Color.timerYellow : Color.timerRed))
                            .font(.system(size: 72, weight: .bold))
                    }
                    .padding(20)
                    .background(Circle().fill(LinearGradient(colors: [Color.timerTopTrailGrad, Color.timerBotLeadGrad], startPoint: .topTrailing, endPoint: .bottomLeading)))
                    .shadow(color: Color.timerShadow, radius: 32, x: 0, y: 0)
                    .overlay (
                        
                        VStack {
                            
                            Spacer()
                            
                            Button(action: {
                                counterVibro += 1
                                viewModel.isActiveTimer.toggle()
                                
                                if viewModel.isActiveTimer == false {
                                    
                                    withAnimation(.spring()) {
                                        
                                        viewModel.isVoting = true
                                    }
                                }
                                
                            }, label: {
                                
                                Image(systemName: viewModel.isActiveTimer ? "pause.fill" : "play.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 40, weight: .bold))
                                    .frame(width: 104, height: 104)
                                    .background(Circle().fill(Color.timerPlayPause))
                            })
                            .buttonStyle(ScaledButton(scaling: 0.9))
                        }
                            .offset(y: 30)
                    )
                    .padding(40)
                    .frame(maxHeight: .infinity, alignment: .center)
                    
                    Text("gfd")
                        .padding()
                        .padding(.bottom, 20)
                        .opacity(0)
                }
            }
            .sensoryFeedbackMod(trigger: $counterVibro)
            
            VStack(alignment: .center, spacing: 10, content: {
                
                Spacer()
                
                if viewModel.isShowHint {
                    
                    hintDesign()
                        .modifier(AnimatedScale())
                }
                
                Button(action: {
                    counterVibro += 1
                    withAnimation(.spring()) {
                        
                        viewModel.isShowHint.toggle()
                    }
                    
                }, label: {
                    
                    HStack(alignment: .center) {
                        
                        Image("info.circle")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.prime)
                            .frame(width: 32, height: 32)
                        
                        Text("SHOW HINT")
                            .foregroundColor(Color.prime)
                            .font(.system(size: 17, weight: .bold))
                    }
                })
                .buttonStyle(ScaledButton(scaling: 0.9))
                .padding()
                .padding(.bottom, 20)
            })
            .opacity(viewModel.isHints && !viewModel.hint.isEmpty ? 1 : 0)
        }
        .onReceive(viewModel.timer) { _ in
            
            if viewModel.isActiveTimer && viewModel.timeRemaining > 0 {
                
                viewModel.timeRemaining -= 1
                
                if viewModel.is_vibration {
                    
                    generator.impactOccurred()
                }
                
            } else if viewModel.timeRemaining == 0 {
                
                viewModel.isActiveTimer = false
                
                withAnimation(.spring()) {
                    
                    viewModel.isVoting = true
                }
            }
        }
        .onReceive(viewModel.$isActiveTimer) { isActive in
            
            UIApplication.shared.isIdleTimerDisabled = isActive
        }
    }
    
    @ViewBuilder
    func hintDesign() -> some View {
        
        ZStack {
            
            Color.black.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture {
                    
                    withAnimation(.spring()) {
                        
                        viewModel.isShowHint = false
                    }
                }
            
            VStack(spacing: 2) {
                
                Spacer()
                
                Text(viewModel.hint)
                    .foregroundColor(.black)
                    .font(.system(size: 17, weight: .regular))
                    .padding(12)
                    .background(
                        
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color.textWhite)
                    )
                    .overlay (
                        
                        VStack {
                            
                            if (viewModel.gameLocation?.hints?.count ?? 0) > 1 {
                                
                                HStack {
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        guard let randomHint = viewModel.gameLocation?.hints?.randomElement() else { return }
                                        
                                        viewModel.hint = randomHint
                                        
                                    }, label: {
                                        Icon(image: "arrow.clockwise")
                                            .background(Circle().fill(.textWhite).shadow(color: .bgButton, radius: 12, x: 0, y: 2))
                                    })
                                    .offset(x: 10, y: -10)
                                }
                            }
                            
                            Spacer()
                        }
                    )
            }
        }
    }
}

#Preview {
    TimerView(viewModel: MainViewModel())
}
