//
//  SwiftUIView.swift
//  SwiftToast
//
//  Created by Petr Makarov on 19/10/2026.
//

import SwiftUI

package struct ToastContainerView<
    Message: View,
    LeftAccessory: View,
    RightAccessory: View
>: View {
    private let options: ToastContainerViewOptions
    private let message: Message
    private let leftAccessory: LeftAccessory
    private let rightAccessory: RightAccessory
    
    package init(
        _ options: ToastContainerViewOptions = ToastContainerViewOptions.default,
        @ViewBuilder message: () -> Message = { EmptyView() },
        @ViewBuilder leftAccessory: () -> LeftAccessory = { EmptyView() },
        @ViewBuilder rightAccessory: () -> RightAccessory = { EmptyView() },
    ) {
        self.options = options
        self.message = message()
        self.leftAccessory = leftAccessory()
        self.rightAccessory = rightAccessory()
    }
    
    package var body: some View {
        if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, macCatalyst 26.0,  *), options.liquidGlassEnabled {
            liquidGlassBody
        }
        else {
            regularBody
        }
    }
    
    @available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, macCatalyst 26.0, *)
    private var liquidGlassBody: some View {
        internalBody
            .glassEffect(
                .clear
                    .tint(options.backgroundColor)
                    .interactive(),
                in: .rect(cornerSize: .init(width: options.cornerRadius, height: options.cornerRadius)))
            .shadow(radius: 3)
    }
    
    private var regularBody: some View {
        internalBody
            .background {
                RoundedRectangle(cornerRadius: options.cornerRadius)
                    .fill(options.backgroundColor)
            }
            
    }
    
    private var internalBody: some View {
        HStack(spacing: options.internalSpacing) {
            
            leftAccessory
            
            message
            
            if options.stretched {
                Spacer(minLength: 0)
            }
            
            rightAccessory
            
        }
        .padding(options.externalSpacing)
    }
}

#Preview {
    ToastContainerView {
        TitleAndMessageView(
            title: "This is a title",
            message: "This is a message"
        )
    }
    
    ToastContainerView {
        TitleAndMessageView(
            title: "This is a title",
            message: "This is a message",
            messageTitleSpacing: 15
        )
    }
    
    ToastContainerView(ToastContainerViewOptions(liquidGlassEnabled: true)) {
        TitleAndMessageView(title: "This is a title")
    }
    
    ToastContainerView {
        TitleAndMessageView(message: "This is a message")
    }
    
    ToastContainerView {
        TitleAndMessageView(
            title: "This is a title",
            message: "This is a message a long long looooooooooooooooooooooooooooooong message long long long long long long long long long long long long long long long long message",
            messageLinesLimit: 3
        )
    }
    
    ToastContainerView {
        TitleAndMessageView(
            title: "This is a title",
        )
    }
    
    ToastContainerView(ToastContainerViewOptions(liquidGlassEnabled: true)) {
        TitleAndMessageView(
            title: "Download complete",
            message: "report.pdf was saved",
        )
    } leftAccessory: {
        Image(systemName: "checkmark.circle.fill")
            .foregroundStyle(.black)
    } rightAccessory: {
        Button {
            // Dismiss toast
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(.black)
        }
    }
    
    ToastContainerView(ToastContainerViewOptions(liquidGlassEnabled: true)) {
        TitleAndMessageView(
            title: "Canvas paused",
        )
    } leftAccessory: {
        HStack(spacing: 0) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
            .foregroundStyle(.red)
            Spacer()
        }
        .frame(maxHeight: 44)
        .frame(width: 44)
        //.background(.blue)
        .padding(0)
    } rightAccessory: {
        Button {
            // Dismiss toast
        } label: {
            HStack(spacing: 0) {
                Image(systemName: "xmark")
                    .foregroundStyle(.red)
                    .background {
                        Circle()
                            .fill(.red.opacity(0.5).blendMode(.lighten))
                            .frame(width: 28, height: 28)
                    }
            }
            .frame(maxHeight: 44)
            .frame(width: 44)
        }
    }
    .frame(height: 44)
}

#Preview("Product ready") {
    
    ToastContainerView(ToastContainerViewOptions(liquidGlassEnabled: true)) {
        TitleAndMessageView(
            title: "Canvas paused",
        )
    } leftAccessory: {
        ImageAccessory(.systemName("checkmark.circle.fill"))
    } rightAccessory: {
        ImageButton(
            .systemName("xmark"),
            withOptions: .init(forgroundColor: .red)
        ) {
            print("xmark tapped")
        }
    }
    
    ToastContainerView(ToastContainerViewOptions(liquidGlassEnabled: false)) {
        TitleAndMessageView(
            title: "Canvas paused",
        )
    } leftAccessory: {
        ImageAccessory(.systemName("checkmark.circle.fill"))
    } rightAccessory: {
        ImageButton(
            .systemName("xmark"),
            withOptions: .init(forgroundColor: .red)
        ) {
            print("xmark tapped")
        }
    }
    
}
