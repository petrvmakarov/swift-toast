//
//  ImageAccessoryView.swift
//  SwiftToast
//
//  Created by Petr Makarov on 26/10/2026.
//

import SwiftUI

public struct ImageAccessory: View {
    private var source: ImageSource
    
    public init(_ source: ImageSource) {
        self.source = source
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            source.image
                .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
            .foregroundStyle(.red)
        }
        //.frame(maxHeight: 44)
        //.frame(width: 44)
        
        //.background(.blue)
        
        //.padding(0)
    }
}

#Preview {
    ImageAccessory(.systemName("checkmark.circle.fill"))
}
