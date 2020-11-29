//
//  HomeView.swift
//  Hydrate
//
//  Created by Quentin Eude on 23/09/2020.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var authState: AuthenticationState
    @ObservedObject var homeViewModel = HomeViewModel()
    @State private var showAddWaterPopover: Bool = false

    var body: some View {
        Group {
            #if os(iOS)
            iOSBody(homeViewModel: homeViewModel)
            #elseif os(macOS)
            macOSBody(homeViewModel: homeViewModel)
            #endif
        }.onAppear {
            homeViewModel.start(authState: authState)
        }
    }

    private func iOSBody(homeViewModel: HomeViewModel) -> some View {
        return NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 24) {
                    if let user = homeViewModel.user, let dailyGoal = homeViewModel.user?.dailyGoal {
                        VStack {
                            CircleWaveView(percent:
                                            homeViewModel.progress,
                                           user: user)
                                .frame(width: 200, height: 200)
                                .padding()
                            HStack(spacing: 16) {
                                VStack(alignment: .trailing) {
                                    Text(L10n.CircularProgress.Drunk.label)
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondaryText)
                                    Text(L10n.CircularProgress.Quantity.label(String(format: "%.0f", homeViewModel.quantityDrinkedToday)))
                                        .font(.system(size: 22, weight: Font.Weight.bold))
                                }
                                Divider()
                                VStack(alignment: .leading) {
                                    Text(L10n.CircularProgress.Goal.label)
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondaryText)
                                    Text(L10n.CircularProgress.Quantity.label(String(format: "%.0f", dailyGoal)))
                                        .font(.system(size: 22, weight: Font.Weight.bold))
                                }
                            }
                        }

                        Menu {
                            Button(L10n.AddDrinkEntry._250ml.Button.label) {
                                homeViewModel.addDrinkEntry(quantity: 250)
                            }
                            Button(L10n.AddDrinkEntry._500ml.Button.label) {
                                homeViewModel.addDrinkEntry(quantity: 500)
                            }
                            Button(L10n.AddDrinkEntry._1000ml.Button.label) {
                                homeViewModel.addDrinkEntry(quantity: 1000)
                            }
                            Button(L10n.AddDrinkEntry._1500ml.Button.label) {
                                homeViewModel.addDrinkEntry(quantity: 1500)
                            }
                            Button("Reset") {
                                homeViewModel.resetDrinkEntriesForToday()
                            }
                            Button(L10n.AddDrinkEntry.Custom.Button.label, action: {})
                        } label: {
                            Button(action: {}) {
                                Text(L10n.Home.AddWater.Button.text)
                                    .frame(width: 150)
                            }
                            .buttonStyle(PrimaryButtonStyle())

                        }

                        VStack(alignment: .leading) {
                            Text(L10n.Home.TodayEntries.title)
                                .font(.system(size: 24, weight: Font.Weight.bold))
                                .padding([.leading, .trailing], 16)
                            VStack {
                                if homeViewModel.todayDrinkEntries.isEmpty {
                                    Text(L10n.Home.DrinkEntriesList.NoDrinkEntry.text)
                                        .foregroundColor(.secondaryText)
                                        .font(.system(size: 14))
                                } else {
                                    List {
                                        ForEach(homeViewModel.todayDrinkEntries, id: \.id) { item in
                                            DrinkEntryCell(drinkEntry: item)
                                                .listRowBackground(Color.lightBackground)
                                        }.onDelete { indexSet in
                                            self.homeViewModel.removeDrinkEntry(at: indexSet)
                                        }
                                    }
                                    .onAppear {
                                        UITableView.appearance().isScrollEnabled = false
                                    }
                                    .cornerRadius(20)
                                    .frame(height: CGFloat(homeViewModel.todayDrinkEntries.count) * 55)
                                }
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } else {
                        EmptyView()
                    }
                }
            }
            .navigationTitle(L10n.Home.Hello.label(homeViewModel.user?.firstname ?? ""))
        }
    }

    private func macOSBody(homeViewModel: HomeViewModel) -> some View {
        return Text("MacOS 💻🎉")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
