//
//  TagButton.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/12/23.
//

import SwiftUI

struct TagButton: View {
    var tag: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag)
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(isSelected ? Color(red: 0.4, green: 0.5, blue: 1) : Color.gray.opacity(0.1) )
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(20)
        }
    }
}
