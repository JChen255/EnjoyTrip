//
//  Currency.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/16/23.
//

import SwiftUI

enum Currency: String, CaseIterable {
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    case jpy = "JPY"
    case cny = "CNY"
    var id: String { self.rawValue }
}

struct CurrencyInfo {
    let conversionRate: Double
    let symbol: String
}

let currencyInfo: [Currency: CurrencyInfo] = [
    .usd: CurrencyInfo(conversionRate: 1.0, symbol: "$"),
    .eur: CurrencyInfo(conversionRate: 0.85, symbol: "€"),
    .gbp: CurrencyInfo(conversionRate: 0.73, symbol: "£"),
    .jpy: CurrencyInfo(conversionRate: 110.3, symbol: "¥"),
    .cny: CurrencyInfo(conversionRate: 6.48, symbol: "¥")
]


