//
//  UserDetailsViewModel.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/13.
//

import Foundation
import Combine

protocol UserDetailsViewDataProviding {
    var hasLoadedAllRepos: Bool { get }
    func fetchUserInfo(forUser userName: String) async throws -> UserInfo?
    func loadGitRepos(forUser userName: String, fromPage pageIndex: Int) async throws -> [UserRepositories]?
}

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
        fetchUserInfo()
    }
    
    private func fetchUserInfo() {
        Task {
            do {
                self.userInfo = try await self.dataProvider.fetchUserInfo(forUser: loginUsername)
            } catch {
                
            }
        }
    }
}

// MARK: UserDetailsViewListner

extension UserDetailsViewModel {
    func loadGitRepos() {
        guard !isLoadingRepos, !dataProvider.hasLoadedAllRepos else { return }
        self.isLoadingRepos = true
        self.page += 1
        Task {
            defer {
                self.isLoadingRepos = false
            }
            
            do {
                let repos = try await self.dataProvider.loadGitRepos(forUser: loginUsername, fromPage: page)
                self.repos.append(contentsOf: repos ?? [])
            } catch { }
        }
    }
}
