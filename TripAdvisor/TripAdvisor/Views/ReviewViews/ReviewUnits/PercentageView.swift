//
//  PercentageView.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/17/23.
//

import SwiftUI

struct BarView: View {
    var percentage: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(Color.gray.opacity(0.5))
                
                Rectangle()
                    .frame(width: min(CGFloat(self.percentage) * geometry.size.width / 100, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(red: 0.4, green: 0.5, blue: 1))
            }
        }
    }
}



struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(percentage: 0.96)
    }
}
