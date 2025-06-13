//
//  UserDetailsViewDataProvider.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/13.
//

import Foundation

final class UserDetailsViewDataProvider: UserDetailsViewDataProviding {
    
    private enum Constant {
        static let keyPage = "page"
        static let keyPerPageLimit = "per_page"
        static let perPageLimit = 30
    }
    
    var hasLoadedAllRepos: Bool = false
    
    func fetchUserInfo(forUser userName: String) async throws -> UserInfo? {
        return try await NetworkManager.shared.request(endpoint: "users/\(userName)", responseType: UserInfo.self)
    }
    
    func loadGitRepos(forUser userName: String, fromPage pageIndex: Int) async throws -> [UserRepositories]? {
        guard !hasLoadedAllRepos else { return [] }
        var parameters: [String : Any] = [Constant.keyPerPageLimit : Constant.perPageLimit]
        parameters[Constant.keyPage] = pageIndex
        let gitRepos = try await NetworkManager.shared.request(endpoint: "users/\(userName)/repos", parameters: parameters, responseType: [UserRepositories].self)
        self.hasLoadedAllRepos = gitRepos.count < Constant.perPageLimit
        return gitRepos
    }
}
