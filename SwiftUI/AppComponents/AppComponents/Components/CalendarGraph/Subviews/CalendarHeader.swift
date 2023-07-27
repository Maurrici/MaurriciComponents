//
//  CalendarHeader.swift
//  LoveMyCapibara
//
//  Created by Maurício de Moura on 06/07/23.
//

import SwiftUI

struct CalendarHeader: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var textColor: Color
    var arrowColor: Color
    
    var body: some View {
        HStack {
            Button {
                viewModel.selectBackYear()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 7, height: 12)
                
            }
            .buttonStyle(.plain)
            .padding(.leading, 10)
            .foregroundColor(arrowColor)
            
            Text("\(viewModel.titleForMonth()) \(viewModel.titleForYear())")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(textColor)
            
            Button {
                viewModel.selectForwardYear()
            } label: {
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 7, height: 12)
                
            }
            .buttonStyle(.plain)
            .padding(.trailing, 10)
            .foregroundColor(arrowColor)
            
            Spacer()
            
            HStack {
                Button {
                    viewModel.selectBackMonth()
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.plain)
                .padding(.leading, 10)
                .foregroundColor(arrowColor)
                
                Button {
                    viewModel.selectForwardMonth()
                } label: {
                    Image(systemName: "chevron.right")
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 10)
                .foregroundColor(arrowColor)
            }
        }
    }
}
