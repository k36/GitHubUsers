//
//  UserListView.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/13.
//

import Combine
import SwiftUI
import SDWebImageSwiftUI

struct UserListView<ViewModel: UserListViewModelProtocol>: View {
    
    @StateObject private var viewModel: ViewModel
    @State private var searchText = ""
    @State private var isFirstLoad = true
    @Environment(\.isLoading) private var isLoading
    @State private var selectedUser: User? = nil
    
    public init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        rowContent
            .listStyle(.plain)
            .navigationTitle("GitHub Users")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: searchText) { newValue in
                guard newValue.count > 0 else {
                    viewModel.dismissSearchUsers()
                    return
                }
                viewModel.searchUsers(with: newValue)
            }
            .onChange(of: viewModel.isLoading) { newValue in
                isLoading.wrappedValue = newValue
            }
            .onAppear {
                guard isFirstLoad else { return }
                Task {
                    await viewModel.loadGitHubUsers()
                    self.isFirstLoad = false
                }
            }
            .sheet(item: $selectedUser) { user in
                UserDetailsView(
                    viewModel: UserDetailsViewModel(
                        loginUsername: user.login ?? "",
                        dataProvider: UserDetailsViewDataProvider()
                    )
                )
            }
    }
    
    
    @ViewBuilder
    private var rowContent: some View {
        List(viewModel.users, id: \.self) { user in
            HStack {
                WebImage(url: URL(string: user.avatarURL ?? ""))
                    .resizable()
                    .frame(width: 75, height: 75)
                    .clipShape(.circle)
                Text(user.login ?? "")
                    .font(.system(size: 22, weight: .medium))
                Spacer()
            }
            .contentShape(Rectangle())
            .onAppear {
                guard user.id == viewModel.lastUserId else { return }
                Task {
                    await viewModel.loadGitHubUsers()
                }
            }
            .onTapGesture {
                selectedUser = user
            }
        }
    }
}

// MARK: Preview

#if DEBUG
private final class UserListViewModelMock: UserListViewModelProtocol {
    var isLoading: Bool = true
    var lastUserId: Int?
    var users: [User] = [
        User(login: "User 1", id: 1, avatarURL: "https://placehold.co/75x75/png"),
        User(login: "User 2", id: 2, avatarURL: "https://placehold.co/75x75/png")
    ]
    func loadGitHubUsers() { }
    func searchUsers(with name: String) { }
    func dismissSearchUsers() { }
}
#Preview {
    UserListView(viewModel: UserListViewModelMock())
}

#endif
