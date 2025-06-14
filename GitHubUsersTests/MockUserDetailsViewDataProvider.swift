//
//  MockUserDetailsViewDataProvider.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/14.
//

import Foundation

@testable import GitHubUsers

final class MockUserDetailsViewDataProvider: UserDetailsViewDataProviding {
    
    var hasLoadedAllRepos: Bool = false
    
    var responseToReturnUserInfo: UserInfo?
    var responseToReturnRepos: [UserRepositories]?
    
    func fetchUserInfo(forUser userName: String) async throws -> UserInfo? {
        return responseToReturnUserInfo
    }
    
    func loadGitRepos(forUser userName: String, fromPage pageIndex: Int) async throws -> [UserRepositories]? {
        return responseToReturnRepos
    }
}
