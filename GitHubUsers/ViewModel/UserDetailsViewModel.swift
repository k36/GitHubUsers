//
//  UserDetailsViewModel.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/13.
//

import Foundation
import Combine

protocol UserDetailsViewState: ObservableObject {
    var userInfo: UserInfo? { get }
    var repos: [UserRepositories] { get }
    var lastRepoId: Int? { get }
    var isLoadingRepos: Bool { get }
}

protocol UserDetailsViewListner {
    func loadUserInfo() async
    func loadGitRepos() async
}

typealias UserInfoViewModelProtocol = UserDetailsViewState & UserDetailsViewListner

final class UserDetailsViewModel: UserInfoViewModelProtocol {
    
    // MARK: Dependencies
    private let dataProvider: UserDetailsViewDataProviding
    private let loginUsername: String
    
    private var cancellables = Set<AnyCancellable>()
    private var page: Int = 0
    
    // MARK: UserDetailsViewState
    @Published var userInfo: UserInfo?
    @Published var repos: [UserRepositories] = []
    @Published var isLoadingRepos: Bool = false
    
    var lastRepoId: Int? {
        guard !repos.isEmpty else { return nil }
        return repos.last?.id
    }
    
    init(loginUsername: String, dataProvider: UserDetailsViewDataProviding) {
        self.loginUsername = loginUsername
        self.dataProvider = dataProvider
    }
}

// MARK: UserDetailsViewListner

extension UserDetailsViewModel {
    
    func loadUserInfo() async {
        do {
            self.userInfo = try await self.dataProvider.fetchUserInfo(forUser: loginUsername)
        } catch { }
        
    }
    
    func loadGitRepos() async {
        guard !isLoadingRepos, !dataProvider.hasLoadedAllRepos else { return }
        self.isLoadingRepos = true
        self.page += 1
        defer {
            self.isLoadingRepos = false
        }
        
        do {
            let repos = try await self.dataProvider.loadGitRepos(forUser: loginUsername, fromPage: page)
            self.repos.append(contentsOf: repos ?? [])
        } catch { }
    }
}
