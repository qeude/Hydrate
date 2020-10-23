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
    var body: some View {
        Observe(obj: HomePageViewModel(authState: authState)) { homeViewModel in
            Group {
                #if os(iOS)
                iOSBody(homeViewModel: homeViewModel)
                #elseif os(macOS)
                macOSBody(homeViewModel: homeViewModel)
                #endif
            }
        }
    }

    private func iOSBody(homeViewModel: HomePageViewModel) -> some View {
        return NavigationView {
            ScrollView {
                if let user = homeViewModel.user, let dailyGoal = homeViewModel.user?.dailyGoal {
                    VStack {
                        CircleWaveView(percent:
                                        homeViewModel.progress,
                                       user: user) {
                            VStack {
                                Text(L10n.CircularProgress.Drunk.label)
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondaryText)
                                Text(L10n.CircularProgress.Drunk.Quantity.label(homeViewModel.quantityDrinkedToday))
                                    .font(.system(size: 18, weight: Font.Weight.bold))
                                    .foregroundColor(.primaryText)
                                Text(L10n.CircularProgress.Drunk.Target.label(dailyGoal))
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondaryText)
                            }
                        }
                        .frame(width: 200, height: 200, alignment: .center)
                        Barchart().frame(height: 150).padding(48)
                        ForEach(homeViewModel.drinkEntries, id: \.id) { item in
                            Text("DrinkEntry (\(item.id ?? "")) at \(item.time!.dateValue()): \(item.quantity)")
                        }
                    }
                }
            }
            .navigationTitle("Hello \(homeViewModel.user?.firstname ?? "")")
            .navigationBarItems(trailing: HStack {
                Button(L10n.Auth.Signout.button, action: signoutTapped)
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
                    Image(systemName: "plus.circle").font(.system(size: 20))
                }
            })
        }
    }

    private func macOSBody(homeViewModel: HomePageViewModel) -> some View {
        return Text("MacOS 💻🎉").toolbar(content: {
            Button(L10n.Auth.Signout.button, action: signoutTapped)
        })
    }

    private func signoutTapped() {
        authState.signout()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
