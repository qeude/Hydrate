//
//  ObserveView.swift
//  Hydrate (iOS)
//
//  Created by Quentin Eude on 24/09/2020.
//

import SwiftUI

struct Observe<T: ObservableObject, V: View>: View {
    @ObservedObject var obj: T
    let content: (T) -> V
    var body: some View { content(obj) }
}
