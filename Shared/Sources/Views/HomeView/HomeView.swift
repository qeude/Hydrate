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
                        CircularProgressBar(progress: Float(homeViewModel.quantityDrinkedToday) / Float(dailyGoal),
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
                        ForEach(homeViewModel.drinkEntries, id: \.id) { item in
                            Text("DrinkEntry (\(item.id ?? "")) at \(item.time!.dateValue()): \(item.quantity)")
                        }
                    }
                }
            }
            .navigationTitle("Hello \(homeViewModel.user?.firstname ?? "")")
            .navigationBarItems(trailing: Button(L10n.Auth.Signout.button, action: signoutTapped))
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
