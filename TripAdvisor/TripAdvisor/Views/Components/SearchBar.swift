//
//  SearchBar.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/12/23.
//
import SwiftUI

struct SearchBar: View {
    @Binding var searchQuery: String
    @Binding var isSearching: Bool
    var viewModel: HomeViewModel
    var onCommit: () -> Void
    
    var body: some View {
        HStack {
            TextField("    Search destinations", text: $searchQuery, onEditingChanged: { isEditing in
                isSearching = isEditing
            }, onCommit: {
                isSearching = false
                onCommit()
            })
            .padding(5)
            .background(.bar)
            .overlay(
                HStack {
                    if isSearching {
                        Button(action: {
                            searchQuery = ""
                            isSearching = false
                        }) {
                        }
                    }
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black.opacity(0.8))
                }
                .padding(.horizontal, 8)
                .foregroundColor(.secondary)
            )
            .cornerRadius(10)
            .onChange(of: searchQuery) { newValue in
                viewModel.filterAndSortDestinations(&viewModel.filteredDestinations)
            }
            Spacer()
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchQuery: .constant(""), isSearching: .constant(false), viewModel: HomeViewModel(), onCommit: {})
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
