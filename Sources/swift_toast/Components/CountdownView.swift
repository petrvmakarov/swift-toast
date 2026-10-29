//
//  CountdownView.swift
//  chipdetector
//
//  Created by Petr Makarov on 06/03/2026.
//
import SwiftUI

fileprivate let DEFAULT_CONTAINER_GAP: CGFloat = 16
fileprivate let DEFAULT_SIZE: CGFloat = 51
fileprivate let DEFAULT_LINE_WIDTH: CGFloat = 2
fileprivate let DEFAULT_GAP_WIDTH: CGFloat = 0.25
fileprivate let DEFAULT_FONT_SIZE: CGFloat = 15

public struct CountdownView: View {
    @State private var remainder: Int = 0
    @State private var countdownTask: Task<Void, Never>?

    var value: TimeInterval
    var color: Color =  .white
    var numberColor: Color? = nil
    var gapColor: Color = .gray
    var size: CGFloat = DEFAULT_SIZE
    var lineWidth: CGFloat = DEFAULT_LINE_WIDTH
    var gapWidth: CGFloat = DEFAULT_GAP_WIDTH
    var fontSize: CGFloat = DEFAULT_FONT_SIZE
    var containerGap: CGFloat = DEFAULT_CONTAINER_GAP
    var onElapsed: (() -> Void)?
    var running: Bool = true
    var liquidGlassEnabled: Bool = true//K.Defaults.liquidGlassEnabled
    
    public init(value: TimeInterval,
                color: Color =  .white,
                numberColor: Color? = nil,
                gapColor: Color = .gray,
                size: CGFloat? = nil, //DEFAULT_SIZE,
                lineWidth: CGFloat? = nil, //DEFAULT_LINE_WIDTH,
                gapWidth: CGFloat? = nil, //DEFAULT_GAP_WIDTH,
                fontSize: CGFloat? = nil, //DEFAULT_FONT_SIZE,
                containerGap: CGFloat? = nil, //DEFAULT_CONTAINER_GAP,
                onElapsed: (() -> Void)? = nil,
                running: Bool = true,
                liquidGlassEnabled: Bool = true) {
        
        self.value = value
        self.color = color
        self.numberColor = numberColor
        self.gapColor = gapColor
        self.size = size ?? DEFAULT_SIZE
        self.lineWidth = lineWidth ?? DEFAULT_LINE_WIDTH
        self.gapWidth = gapWidth ?? DEFAULT_GAP_WIDTH
        self.fontSize = fontSize ?? DEFAULT_FONT_SIZE
        self.containerGap = containerGap ?? DEFAULT_CONTAINER_GAP
        self.onElapsed = onElapsed
        self.running = running
        self.liquidGlassEnabled = liquidGlassEnabled
    }
    
    var evaluatedNumberColor: Color {
        if let numberColor {
            return numberColor
        }
        return color
    }
    
    var circleSize: CGFloat {
        size - containerGap
    }
    
    var formattedRemainder: String {
        return remainder >= 0 ? "\(remainder)" : ""
    }
    var totalSeconds: Int {
        max(Int(ceil(value)), 0)
    }
    var circleProgress: CGFloat {
        guard totalSeconds > 0 else { return 0 }
        let progress = CGFloat(remainder) / CGFloat(totalSeconds)
        return min(max(progress, 0), 1)
    }
     
    func startCountdown(resume: Bool = false) {
        if (!resume) {
            cancelCountdown()
            remainder = totalSeconds
        }
        
        guard totalSeconds > 0 else {
            onElapsed?()
            return
        }
        if !running {
            cancelCountdown()
            return
        }
        countdownTask = Task {
            while !Task.isCancelled && remainder >= 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard !Task.isCancelled else { return }
                
                remainder -= 1
                if remainder < 0 {
                    onElapsed?()
                    return
                }
            }
        }
    }
    
    func cancelCountdown() {
        countdownTask?.cancel()
        countdownTask = nil
    }
    
    @ViewBuilder
    var circle: some View {
        Circle()
            .trim(from: 0, to: circleProgress)
            .stroke(
                color,
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .round
                )
            )
            .frame(width: circleSize, height: circleSize)
    }
    
    @ViewBuilder
    var circleWithLiquidGlassAwareness: some View {
        if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, macCatalyst 26.0,  *), liquidGlassEnabled {
            Circle()
                .stroke(
                    .clear,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .frame(width: circleSize, height: circleSize)
                .glassEffect(.clear.tint(color.opacity(0.3)), in: Circle()
                    .trim(from: 0, to: circleProgress)
//                    .stroke(lineWidth: lineWidth + gapWidth * 2)
                    .stroke(
                               style: StrokeStyle(
                                   lineWidth: lineWidth + gapWidth * 2,
                                   lineCap: .round
                               )
                           )
                )
        }
        else {
            Circle()
                .trim(from: 0, to: circleProgress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .frame(width: circleSize, height: circleSize)
        }
    }
    
    public var body: some View {
        ZStack {
            circleWithLiquidGlassAwareness
                .animation(.linear(duration: 1), value: circleProgress)
                .rotationEffect(.degrees(-90))
            
            Text(formattedRemainder)
                .id(formattedRemainder)
                .transition(.scale.animation(.spring).combined(with: .opacity))
                .foregroundColor(evaluatedNumberColor)
                .font(.system(size: fontSize)).bold()
        }
        .frame(width: size, height: size)
        .onAppear {
            startCountdown()
        }
        .onChange(of: value) { _, _ in
            startCountdown()
        }
        .onChange(of: running) {
            if !running {
                cancelCountdown()
            } else {
                startCountdown(resume: true)
            }
        }
        .onDisappear {
            cancelCountdown()
        }
    }
}

#Preview {
    @Previewable @State var running = true
    VStack {
        Spacer()
        CountdownView(value: 10, running: running)
        CountdownView(value: 10, color: .white, gapColor: .clear, size: 60, lineWidth: 5, gapWidth: 2, fontSize: 25)
        CountdownView(value: 10, color: .white, numberColor: .blue, gapColor: .clear, size: 60, lineWidth: 5, gapWidth: 2, fontSize: 25)
        CountdownView(value: 10, size: 80, lineWidth: 6, gapWidth: 3, fontSize: 35)
        CountdownView(value: 10, size: 120, lineWidth: 8, gapWidth: 3.5, fontSize: 55)
        Spacer()
        HStack {
            Button {
                running.toggle()
            } label: {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 44)
                    Image(systemName: running ? "pause" : "play")
                }
            }
            
        }
        Spacer()
    }
    
}
