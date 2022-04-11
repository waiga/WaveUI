//
//  Home.swift
//  WaveUI
//
//  Created by 김미향 on 2022/04/11.
//

import SwiftUI

struct Home: View {
    @State var progress: CGFloat = 0.5
    @State var startAnimation: CGFloat = 0
    var body: some View {
        VStack {
            Image(systemName: "circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding(10)
                .background(.white, in: Circle())
                .foregroundColor(.pink)
            
            Text("iJustine")
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            // MARK: Wave Form
            GeometryReader{proxy in
                let size = proxy.size
                ZStack {
                    // MARK: Water Drop
                    Image(systemName: "heart.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                    // Streching in X Axis
                        .scaleEffect(x: 1, y: 1)
                        .offset(y: -1)
                    // Wave Form Shape, offset: size.width ->
                    WaterWave(progress: progress, waveHeight: 0.03, offset: startAnimation)
                        .fill(Color("Red"))
                    // Water Drops
                        .overlay(content: {
                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 15, height: 15)
                                    .offset(x: -20)
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 15, height: 15)
                                    .offset(x: 40, y: 30)
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 25, height: 25)
                                    .offset(x: -30, y: 80)
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 10, height: 10)
                                    .offset(x: 40, y: 100)
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 10, height: 10)
                                    .offset(x: -40, y: 50)
                                
                            }
                        })
                    
                    // Masking into Drop Shape
                        .mask {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                //.padding(10)
                                
                        }
                    // Add Button
                        .overlay(alignment: .bottom) {
                            Button {
                                progress += 0.1
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 40, weight: .black))
                                    .foregroundColor(Color("Blue"))
                                    .shadow(radius: 2)
                                    .padding(25)
                                    .background(.white, in: Circle())
                            }
                            .offset(y: 40)
                        }
                }
                .frame(width: size.width, height: size.height, alignment: .center)
                .onAppear {
                    // Lopping Animation
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)){
                        // if you set value less than the rect width it will not finish completely
                        startAnimation = size.width
                    }
                }
                
            }
            .frame(height: 350)
            
            Slider(value: $progress)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("BG"))
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct WaterWave: Shape{
    
    var progress: CGFloat
    // wave height
    var waveHeight: CGFloat
    // Initial Animation Start
    var offset: CGFloat
    // Enabling Animation
    var animatableData: CGFloat{
        get {offset}
        set {offset = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        return Path{path in
            path.move(to: .zero)
            
            // MARK: Drawing Waves using Sine
            let progressHeight: CGFloat = (1 - progress) * rect.height
            let height = waveHeight * rect.height
            
            for value in stride(from: 0, to: rect.width, by: 2){
                let x: CGFloat = value
                let sine: CGFloat = sin(Angle(degrees: value + offset).radians)
                let y: CGFloat = progressHeight + (height * sine)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            // Botton Portion
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
    }
}
