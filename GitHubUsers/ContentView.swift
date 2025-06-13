//
//  ContentView.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur on 2025/06/13.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            UserListView(viewModel: UserListViewModel(dataProvider: UserListViewDataProvider()))
        }
        .environment(\.isLoading, $isLoading)
        .hudOverlay(isLoading)
    }
}

struct LoadingEnvironmentKey: EnvironmentKey {
    public static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isLoading: Binding<Bool> {
        get {
            self [LoadingEnvironmentKey.self]
        }
        set {
            self [LoadingEnvironmentKey.self] = newValue
        }
    }
}

#Preview {
    ContentView()
}
