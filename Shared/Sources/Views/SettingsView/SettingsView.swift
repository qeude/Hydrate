//
//  SettingsView.swift
//  Hydrate
//
//  Created by Quentin Eude on 14/10/2020.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authState: AuthenticationState
    @ObservedObject var settingsViewModel = SettingsViewModel()
    @State private var isEditable = false

    var body: some View {
        Group {
            #if os(iOS)
            iOSBody(settingsViewModel: settingsViewModel)
            #elseif os(macOS)
            macOSBody(settingsViewModel: settingsViewModel)
            #endif
        }.onAppear {
            settingsViewModel.start(authState: self.authState)
        }
    }

    private func iOSBody(settingsViewModel: SettingsViewModel) -> some View {
        return NavigationView {
            ZStack {
                if settingsViewModel.isLoaded {
                    Form {
                        Section(header: Text(L10n.Settings.Firstname.Label.text)) {
                            TextField(L10n.Settings.Firstname.Placeholder.text, text: $settingsViewModel.firstname)
                                .disabled(!isEditable)
                        }
                        Section(header: Text(L10n.Settings.DailyGoal.Label.text)) {
                            Stepper(value: $settingsViewModel.dailyGoal, in: 500...5000, step: 100) {
                                Text(L10n.Settings.DailyGoal.value(settingsViewModel.dailyGoal, "ml"))
                            }.disabled(!isEditable)
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle(L10n.Settings.Title.text)
            .navigationBarItems(trailing: HStack {
                Button(isEditable ? L10n.Common.save : L10n.Common.edit) {
                    if isEditable {
                        settingsViewModel.saveSettings()
                    }
                    isEditable.toggle()
                }
            })
        }
    }

    private func macOSBody(settingsViewModel: SettingsViewModel) -> some View {
        return Text("MacOS 💻🎉")
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
