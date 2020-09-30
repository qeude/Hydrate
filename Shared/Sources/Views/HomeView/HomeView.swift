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
            ZStack {
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
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                VStack {
                    CircularProgressBar(progress: .constant(0.25))
                        .frame(width: 200, height: 200, alignment: .center)
                    List {
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
