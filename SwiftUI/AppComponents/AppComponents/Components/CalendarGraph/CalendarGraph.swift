//
//  CalendarGraph.swift
//  LoveMyCapibara
//
//  Created by Maurício de Moura on 05/07/23.
//

import SwiftUI

struct CalendarGraphView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    var updateEvents: (_ date: Date) -> [Date]
    @StateObject var viewModel: CalendarViewModel
    
    var headerTextColor: Color = .black
    var headerArrowColor: Color = .black
    var weekDaysTextColor: Color = .gray
    var daysDefaultColor: Color = .black
    var daysSelectedColor: Color = .white
    var backgroundColor: Color = .white
    
    init(startDate: Binding<Date>, updateEvents: @escaping (_ date: Date) -> [Date] = { _ in return [] }) {
        _startDate = startDate
        _endDate = .constant(Date.now)
        _viewModel = StateObject(wrappedValue: CalendarViewModel(startDate.wrappedValue))
        self.updateEvents = updateEvents
    }
    
    init(startDate: Binding<Date>, endDate: Binding<Date>, updateEvents: @escaping (_ date: Date) -> [Date] = { _ in return [] }) {
        _startDate = startDate
        _endDate = endDate
        _viewModel = StateObject(wrappedValue: CalendarViewModel(startDate.wrappedValue, endDate: endDate.wrappedValue))
        self.updateEvents = updateEvents
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    CalendarHeader(viewModel: viewModel, textColor: headerTextColor, arrowColor: headerArrowColor)
                        .font(.system(size: 20))
                    
                    VStack(spacing: 3) {
                        HStack(spacing: 0) {
                            ForEach(viewModel.days, id: \.self) { day in
                                Text("\(day)")
                                    .frame(height: 36)
                                    .frame(maxWidth: .infinity)
                                    .font(.system(size: 13, weight: .bold))
                            }
                        }
                        .foregroundColor(weekDaysTextColor)
                        
                        VStack(spacing: 6) {
                            ForEach(viewModel.weeks, id: \.self) { week in
                                ZStack {
                                    HStack(spacing: 0) {
                                        ForEach(Array(week.enumerated()), id: \.offset) { index, day in
                                            CalendarDay(viewModel: viewModel, week: week, day: day, index: index, colorSelected: daysDefaultColor, colorDefault: daysSelectedColor)
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
            }
        }
        .background(backgroundColor)
        .onChange(of: viewModel.firstDate ?? nil) { _ in
            if let newDate = viewModel.firstDate {
                startDate = newDate
            }
        }
        .onChange(of: viewModel.secondDate ?? nil) { _ in
            if let newDate = viewModel.secondDate {
                endDate = newDate
            }
        }
        .onChange(of: viewModel.date) { newValue in
            viewModel.events = updateEvents(newValue)
        }
        .onAppear {
            viewModel.events = updateEvents(viewModel.date)
        }
    }
}

extension CalendarGraphView {
    func calendarColorConfig(_ colorConfig: CalendarColorConfig) -> some View {
        var view = CalendarGraphView(startDate: self.$startDate, endDate: self.$endDate)
        view.headerTextColor = colorConfig.headerTextColor
        view.headerArrowColor = colorConfig.headerArrowColor
        view.weekDaysTextColor = colorConfig.weekDaysTextColor
        view.daysDefaultColor = colorConfig.daysDefaultColor
        view.daysSelectedColor = colorConfig.daysSelectedColor
        view.backgroundColor = colorConfig.backgroundColor
        return view
    }
}

struct CalendarColorConfig {
    var headerTextColor: Color
    var headerArrowColor: Color
    var weekDaysTextColor: Color
    var daysDefaultColor: Color
    var daysSelectedColor: Color
    var backgroundColor: Color
    
    init(headerTextColor: Color = .black, headerArrowColor: Color = .black, weekDaysTextColor: Color = .gray, daysDefaultColor: Color = .black, daysSelectedColor: Color = .white, backgroundColor: Color = .black) {
        self.headerTextColor = headerTextColor
        self.headerArrowColor = headerArrowColor
        self.weekDaysTextColor = weekDaysTextColor
        self.daysDefaultColor = daysDefaultColor
        self.daysSelectedColor = daysSelectedColor
        self.backgroundColor = backgroundColor
    }
}

// MARK: - PREVIEW
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarGraphView(startDate: .constant(Date.now), endDate: .constant(Date.now))
            .calendarColorConfig(
                CalendarColorConfig(headerTextColor: .pink, headerArrowColor: .white, weekDaysTextColor: .black, daysDefaultColor: .red, daysSelectedColor: .white, backgroundColor: .mint))
    }
}
