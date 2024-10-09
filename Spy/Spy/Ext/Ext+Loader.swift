//
//  Ext+Loader.swift
//  Spy
//
//  Created by Вячеслав on 12/1/23.
//

import SwiftUI

struct Loader: View {
    
    let trackerRotation: Double = 2
    let animationDuration: Double = 0.55
    
    @State var isAnimating: Bool = false
    @State var circleStart: CGFloat = 0.17
    @State var circleEnd: CGFloat = 0.325
    
    @State var rotationDegree: Angle = Angle.degrees(0)
    
    @State var width: CGFloat
    @State var height: CGFloat
    @State var color: Color
    
    var body: some View {
        
        ZStack {
            
            ZStack {
                
                Circle()
                    .trim(from: circleStart, to: circleEnd)
                    .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .fill(color)
                    .rotationEffect(self.rotationDegree)
            }
            .frame(width: width, height: height)
            .onAppear() {
                
                self.animateLoader()
                
                Timer.scheduledTimer(withTimeInterval: self.trackerRotation * self.animationDuration + (self.animationDuration), repeats: true) { (mainTimer) in
                    
                    self.animateLoader()
                }
            }
        }
    }
    
    func getRotationAngle() -> Angle {
        
        return .degrees(360 * self.trackerRotation) + .degrees(120)
    }
    
    func animateLoader() {
        
        withAnimation(.spring(response: animationDuration * 2 )) {
            
            self.rotationDegree = .degrees(-57.5)
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            
            withAnimation(.easeInOut(duration: self.trackerRotation * self.animationDuration)) {
                
                self.rotationDegree += self.getRotationAngle()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 1.25, repeats: false) { _ in
            
            withAnimation(.easeOut(duration: (self.trackerRotation * self.animationDuration) / 2.25 )) {
                
                self.circleEnd = 0.925
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: trackerRotation * animationDuration, repeats: false) { _ in
            
            self.rotationDegree = .degrees(47.5)
            
            withAnimation(.easeOut(duration: self.animationDuration)) {
                
                self.circleEnd = 0.325
            }
        }
    }
}
