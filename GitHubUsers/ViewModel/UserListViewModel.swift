//
//  UserListViewModel.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/13.
//

import Combine
import Foundation

protocol UserListViewState: ObservableObject {
    var users: [User] { get }
    var lastUserId: Int? { get }
    var isLoading: Bool { get }
}

protocol UserListViewListner {
    func loadGitHubUsers() async
    func searchUsers(with name: String)
    func dismissSearchUsers()
}

typealias UserListViewModelProtocol = UserListViewState & UserListViewListner

final class UserListViewModel: UserListViewModelProtocol {
    
    // MARK: Dependencies
    private let dataProvider: UserListViewDataProviding
    private var cancellables = Set<AnyCancellable>()
    
    private let searchTextPublisher = PassthroughSubject<String, Never>()
    private var usersCache: [User] = []
    private var isSearching: Bool = false
    
    // MARK: UserListViewState
    @Published var isLoading: Bool = false
    @Published var users: [User] = []
    var lastUserId: Int? {
        guard !users.isEmpty else { return nil }
        return users.last?.id
    }
    
    init(dataProvider: UserListViewDataProviding) {
        self.dataProvider = dataProvider
        subscribeForSearchTex()
    }
    
    private func subscribeForSearchTex() {
        searchTextPublisher
            .debounce(for: .milliseconds(700), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { [weak self] searchText in
                guard let self, !isLoading, !searchText.isEmpty else { return }
                self.isLoading = true
                self.users.removeAll()
                Task {
                    defer {
                        self.isLoading = false
                    }
                    
                    do {
                        let users = try await self.dataProvider.searchUsers(with: searchText)
                        self.users.append(contentsOf: users)
                    } catch { }
                }
            })
            .store(in: &cancellables)
    }
    
    private func cancelSearch() {
        self.users = self.usersCache
        isSearching = false
        searchTextPublisher.send("")
    }
}

// MARK: UserListViewListner

extension UserListViewModel {
    
    @MainActor
    func loadGitHubUsers() async {
        guard !isLoading, !dataProvider.hasLoadedAllUsers, !isSearching else { return }
        self.isLoading = true
        do {
            let users: [User] = try await self.dataProvider.loadGitHubUsers(index: self.lastUserId)
            self.users.append(contentsOf: users)
            self.usersCache = self.users
        } catch { }
        self.isLoading = false
    }
    
    func searchUsers(with name: String) {
        guard name.count > 0 else {
            cancelSearch()
            return
        }
        isSearching = true
        searchTextPublisher.send(name)
    }
    
    func dismissSearchUsers() {
        cancelSearch()
    }
}
