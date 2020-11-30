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

    private func iOSBody(reportsViewModel: ReportsViewModel) -> some View {
        return NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 24) {
                    Picker(selection: $reportsViewModel.selectedGranularity, label: Text("Select")) {
                        ForEach(0 ..< reportsViewModel.segmentedPickerPossibilities.count) {
                            Text(reportsViewModel.segmentedPickerPossibilities[$0].localized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(16)

                    DateChooserView(label: reportsViewModel.getBarchartLabel(),
                                    leftAction: reportsViewModel.setPreviousDateAreaBarchart,
                                    rightAction: reportsViewModel.setNextDateAreaBarchart,
                                    leftButtonDisable: false,
                                    rightButtonDisable: reportsViewModel.barchartEndDate?.isToday ?? true)

                    Barchart(data: reportsViewModel.barchartEntries,
                             maxValue: reportsViewModel.barchartMaxValue,
                             labelSuffix: "ml")
                        .frame(height: 150)
                        .padding([.leading, .trailing], 24)

                    VStack(alignment: .leading, spacing: 16) {
                        Text(L10n.Reports.Statistics.title)
                            .font(.system(size: 24, weight: Font.Weight.bold))
                        HStack {
                            StatisticCell(title: "Average intake", value: "1900ml")
                            StatisticCell(title: "Drink Frequency", value: "6/day")
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

            }
            .navigationTitle(L10n.Tab.Reports.item)
        }
    }

    private func macOSBody(reportsViewModel: ReportsViewModel) -> some View {
        return Text("MacOS 💻🎉")
    }

}
struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportsView()
    }
}
