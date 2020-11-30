//
//  AddCustomDrinkQuantityView.swift
//  Hydrate
//
//  Created by Quentin Eude on 30/11/2020.
//

import SwiftUI

struct AddCustomDrinkQuantityView: View {
    @EnvironmentObject var authState: AuthenticationState
    @ObservedObject var addCustomViewModel = AddCustomViewModel()

    @Binding var showingSheet: Bool
    @State private var quantity: String = ""

    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            NavigationView {
                VStack(alignment: .center, spacing: 24) {
                    TextField(L10n.AddCustom.Quantity.Placeholder.text, text: $quantity)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(PrimaryTextFieldStyle())

                    Button(
                        action: {
                            addCustomViewModel.addDrinkEntry(quantity: quantity)
                            self.showingSheet = false
                        },
                        label: {
                            Text(L10n.AddCustom.Add.Button.text)
                                .frame(maxWidth: .infinity)
                        }
                    ).buttonStyle(PrimaryButtonStyle())

                    Spacer()
                }.padding(16)
                .navigationTitle(L10n.AddCustom.Title.text)
            }
        }
        .onAppear {
            self.addCustomViewModel.start(authState: authState)
        }
    }
}

struct AddCustomDrinkQuantityView_Previews: PreviewProvider {
    static var previews: some View {
        AddCustomDrinkQuantityView(showingSheet: .constant(true))
    }
}
