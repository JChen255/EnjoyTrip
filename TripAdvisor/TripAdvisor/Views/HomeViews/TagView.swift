//
//  TagView.swift
//  TripAdvisor
//
//  Created by Yunao Guo on 8/12/23.
//

import SwiftUI

struct TagView: View {
    @ObservedObject var viewModel: TagViewModel
    
    var body: some View {
        
        HStack{
            Image(systemName: "tag")
                
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.tags, id: \.self) { tag in
                        TagButton(tag: tag, isSelected: viewModel.isSelected(tag: tag)) {
                            viewModel.toggleTag(tag)
                            viewModel.applyMultipleTagsFilter(destinations: &viewModel.homeViewModel.filteredDestinations)
                            viewModel.homeViewModel.applySort()
                        }

                    }
                }
                .padding(.horizontal)
            }
        }
        
    }
}

