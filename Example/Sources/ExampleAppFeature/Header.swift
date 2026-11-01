//
//  Header.swift
//  SwiftToast
//
//  Created by Petr Makarov on 01/11/2026.
//
import SwiftUI

struct Header: View {
    
    private var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
    }
}
