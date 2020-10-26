//
//  ReportView.swift
//  Hydrate (iOS)
//
//  Created by Quentin Eude on 25/10/2020.
//

import SwiftUI

struct ReportsView: View {
    @EnvironmentObject var authState: AuthenticationState
    @ObservedObject var reportsViewModel = ReportsViewModel()

    var body: some View {
        Group {
            #if os(iOS)
            iOSBody(reportsViewModel: reportsViewModel)
            #elseif os(macOS)
            macOSBody(reportsViewModel: reportsViewModel)
            #endif
        }.onAppear {
            reportsViewModel.start(authState: authState)
        }
    }
}

private func iOSBody(reportsViewModel: ReportsViewModel) -> some View {
    return NavigationView {
        ScrollView(.vertical) {
            DateChooserView(label: reportsViewModel.getBarchartLabel(),
                            leftAction: reportsViewModel.setPreviousWeekBarchart,
                            rightAction: reportsViewModel.setNextWeekBarchart,
                            leftButtonDisable: false,
                            rightButtonDisable: reportsViewModel.barchartEndDate.isYesterday)
                .padding(.top, 24)
            Barchart(data: reportsViewModel.barchartEntries,
                     maxValue: reportsViewModel.user?.dailyGoal ?? 0.0,
                     labelSuffix: "ml")
                .frame(height: 150)
                .padding([.leading, .trailing], 24)

        }
        .navigationTitle(L10n.Tab.Reports.item)
    }
}

private func macOSBody(reportsViewModel: ReportsViewModel) -> some View {
    return Text("MacOS 💻🎉")
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportsView()
    }
}