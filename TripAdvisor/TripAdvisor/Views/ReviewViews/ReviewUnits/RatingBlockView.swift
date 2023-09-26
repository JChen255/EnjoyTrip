//
//  RatingBlockView.swift
//  TripAdvisor
//
//  Created by wade hu on 8/14/23.
//

import SwiftUI

import SwiftUI

struct RatingBlockView: View {
    
    private var excellentCount: Int
    private var goodCount: Int
    private var averageCount: Int
    private var poorCount: Int
    private var terribleCount: Int
    
    init(excellentCount: Int, goodCount: Int, averageCount: Int, poorCount: Int, terribleCount: Int) {
        self.excellentCount = excellentCount
        self.goodCount = goodCount
        self.averageCount = averageCount
        self.poorCount = poorCount
        self.terribleCount = terribleCount
    }
    
    private var totalCount: Int {
        excellentCount + goodCount + averageCount + poorCount + terribleCount
    }
    
    private func countForStars(_ stars: Int) -> Int {
        switch stars {
        case 5: return excellentCount
        case 4: return goodCount
        case 3: return averageCount
        case 2: return poorCount
        case 1: return terribleCount
        default: return 0
        }
    }
    
    private func calculatePercentage(_ count: Int) -> Double {
        return totalCount > 0 ? Double(count) / Double(totalCount) * 100.0 : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach((1...5).reversed(), id: \.self) { stars in
                HStack(spacing: 0) {
                    Text("\(stars) star")
                        .font(.system(size: 15))
                        .fontWeight(.light)
                        .foregroundColor(Color(hue: 0.591, saturation: 0.087, brightness: 0.393))
                        .frame(height: 25)
                    Spacer()
                    BarView(percentage: calculatePercentage(countForStars(stars)))
                        .frame(width: 150, height: 15)
                    Spacer()
                    Text("\(calculatePercentage(countForStars(stars)), specifier: "%.f") %")
                        .font(.system(size: 15))
                        .fontWeight(.light)
                        .foregroundColor(Color(hue: 0.591, saturation: 0.087, brightness: 0.393))
                        .frame(width: 50)
                        .padding(.horizontal, 5)
                }
            }
        }
        .frame(width: 280)
    }
}

struct RatingBlockView_Previews: PreviewProvider {
    static var previews: some View {
        RatingBlockView(excellentCount: 9, goodCount: 22, averageCount: 7, poorCount: 3, terribleCount: 2)
    }
}
