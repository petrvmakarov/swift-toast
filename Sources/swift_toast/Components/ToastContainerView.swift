//
//  SwiftUIView.swift
//  SwiftToast
//
//  Created by Petr Makarov on 31/10/2026.
//

import SwiftUI

package struct PaddingConfiguration {
    var insets = EdgeInsets()
    var isCustomized = false

    mutating func add(_ length: CGFloat, to edges: Edge.Set) {
        if edges.contains(.top) {
            insets.top += length
        }
        if edges.contains(.leading) {
            insets.leading += length
        }
        if edges.contains(.bottom) {
            insets.bottom += length
        }
        if edges.contains(.trailing) {
            insets.trailing += length
        }
        isCustomized = true
    }
}

package struct HStackConfiguration {
    var alignment: VerticalAlignment = .center
    var spacing: CGFloat? = nil

    mutating func set(
        _ alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil
    ) {
        self.alignment = alignment
        self.spacing = spacing
    }
}

package struct PaddingConfigurableView<Content: View>: View {
    private var paddingConfig = PaddingConfiguration()
    private let content: Content

    package init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    fileprivate init(
        paddingConfig: PaddingConfiguration,
        @ViewBuilder content: () -> Content
    ) {
        self.paddingConfig = paddingConfig
        self.content = content()
    }
    

    @ViewBuilder package var body: some View {
        Group {
            if paddingConfig.isCustomized {
                content
                    .padding(paddingConfig.insets)
            }
            else {
                content
                    .padding(.all, nil)
            }
        }
    }
}

package struct ToastContainerView<
    Message: View,
    LeftAccessory: View,
    RightAccessory: View
>: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private let options: ToastContainerViewOptions
    private let message: Message
    private let leftAccessory: LeftAccessory
    private let rightAccessory: RightAccessory
    
    private var containerPadding = PaddingConfiguration()
    private var leadingAccessoryPadding = PaddingConfiguration(insets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), isCustomized: true)
    private var trailingAccessoryPadding = PaddingConfiguration(insets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), isCustomized: true)
    private var messagePadding = PaddingConfiguration(insets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), isCustomized: true)
    private var containerStackConfig = HStackConfiguration()
    
    private var regularBodyShadow: Shadow {
        if colorScheme == .dark {
            return K.Defaults.darkThemeToastShadow
        }
        return K.Defaults.lightThemeToastShadow
    }
    
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

    /// Sets the padding applied inside the toast container.
    func containerPadding(
        _ edges: Edge.Set = .all,
        _ length: CGFloat
    ) -> Self {
        var copy = self
        copy.containerPadding.add(length, to: edges)
        return copy
    }
    
    /// Sets the padding applied inside the toast leading accessory.
    func leadingAccessoryPadding(
        _ edges: Edge.Set = .all,
        _ length: CGFloat
    ) -> Self {
        var copy = self
        copy.containerPadding.add(length, to: edges)
        return copy
    }
    
    /// Sets the padding applied inside the toast trailing accessory.
    func trailingAccessoryPadding(
        _ edges: Edge.Set = .all,
        _ length: CGFloat
    ) -> Self {
        var copy = self
        copy.containerPadding.add(length, to: edges)
        return copy
    }
    
    /// Sets the padding applied inside the toast message container.
    func messagePadding(
        _ edges: Edge.Set = .all,
        _ length: CGFloat
    ) -> Self {
        var copy = self
        copy.containerPadding.add(length, to: edges)
        return copy
    }

    /// Sets vertical alignment and spacing inside container
    func containerAlignmentAndSpacing(
        _ alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil
    ) -> Self {
        var copy = self
        copy.containerStackConfig.set(alignment, spacing: spacing)
        return copy
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
                    .shadow(color: regularBodyShadow.color, radius: regularBodyShadow.radius)
                    .edgesIgnoringSafeArea(options.ignoreSafeArea)
            }
    }


    private var internalBody: some View {
        PaddingConfigurableView(paddingConfig: containerPadding) {
            HStack(
                alignment: containerStackConfig.alignment,
                spacing: containerStackConfig.spacing
            ) {
                PaddingConfigurableView(paddingConfig: leadingAccessoryPadding) {
                    HStack {
                        leftAccessory
                    }
                }
                PaddingConfigurableView(paddingConfig: messagePadding) {
                    HStack {
                        message
                    }
                    if options.stretched {
                        Spacer(minLength: 0)
                    }
                }
                PaddingConfigurableView(paddingConfig: trailingAccessoryPadding) {
                    HStack {
                        rightAccessory
                    }
                }
            }
        }
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
            options: ToastOptions(liquidGlassEnabled: true)
        )
    } leftAccessory: {
        ImageAccessory(.systemName("checkmark.circle.fill"))
    } rightAccessory: {
        ImageButton(
            .systemName("xmark"),
            withOptions: .init(foregroundColor: .red)
        ) {
            print("xmark tapped")
        }
    }
    
    ToastContainerView(ToastContainerViewOptions(liquidGlassEnabled: false)) {
        TitleAndMessageView(
            title: "Canvas paused",
            options: ToastOptions(liquidGlassEnabled: false)
        )
    } leftAccessory: {
        ImageAccessory(.systemName("checkmark.circle.fill"))
    } rightAccessory: {
        ImageButton(
            .systemName("xmark"),
            withOptions: .init(foregroundColor: .red)
        ) {
            print("xmark tapped")
            print("\(ToastContainerViewOptions(liquidGlassEnabled: false).backgroundColor)")
        }
    }
    
}
