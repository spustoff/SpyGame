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
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
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
                                .foregroundColor(Color("bezhev"))
                                .font(.system(size: 34, weight: .semibold))
                        }
                        
                        Text(viewModel.timeRemaining == viewModel.totalTime ? "Press play when all players are ready to start the timer" : "Press pause at any time to arrange a vote or for a spy to choose a location")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .regular))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    ZStack {
                        
                        Circle()
                            .trim(from: 0, to: 0.75)
                            .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                            .rotationEffect(Angle(degrees: 135))
                            .foregroundColor(Color("bgGray").opacity(0.3))
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(viewModel.timeRemaining) / CGFloat(viewModel.totalTime) * 0.75)
                            .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                            .foregroundColor(Color("primary"))
                            .rotationEffect(Angle(degrees: 135))
                            .animation(.linear(duration: 0.2), value: viewModel.timeRemaining)
                        
                        Text(timeString(time: viewModel.timeRemaining))
                            .foregroundColor(viewModel.timeRemaining > 10 ? Color.white : (viewModel.timeRemaining > 5 ? Color.yellow : Color.red))
                            .font(.system(size: 65, weight: .bold))
                    }
                    .padding(20)
                    .background(Circle().fill(Color("timerBg")))
                    .shadow(color: Color("timerShadow"), radius: 20, x: 0, y: 0)
                    .overlay (
                        
                        VStack {
                            
                            Spacer()
                            
                            Button(action: {
                                
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
                                    .frame(width: 122, height: 122)
                                    .background(Circle().fill(Color("timerButtonColor")))
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
            
            VStack(alignment: .center, spacing: 10, content: {
                
                Spacer()
                
                if viewModel.isShowHint {
                    
                    hintDesign()
                        .modifier(AnimatedScale())
                }
                
                Button(action: {
                    
                    withAnimation(.spring()) {
                        
                        viewModel.isShowHint.toggle()
                    }
                    
                }, label: {
                    
                    HStack(alignment: .center) {
                        
                        Image("hints.icon")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color("primary"))
                            .frame(width: 35, height: 35)
                        
                        Text("SHOW HINT")
                            .foregroundColor(Color("primary"))
                            .font(.system(size: 17, weight: .semibold))
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
                    .font(.system(size: 15, weight: .regular))
                    .padding(15)
                    .background(
                        
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
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
                                        
                                        Image(systemName: "arrow.clockwise")
                                            .foregroundColor(Color("primary"))
                                            .font(.system(size: 14, weight: .medium))
                                            .frame(width: 28, height: 28)
                                            .background(Circle().fill(.white).shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0))
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
