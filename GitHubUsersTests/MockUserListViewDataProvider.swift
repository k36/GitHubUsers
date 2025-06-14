//
//  MockUserListViewDataProvider.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/14.
//

import Foundation

@testable import GitHubUsers

final class MockUserListViewDataProvider: UserListViewDataProviding {
    
    var hasLoadedAllUsers: Bool = false
    
    var responseToReturn: [User]?
    var responseToReturnSearch: UsersSearch?
    
    func loadGitHubUsers(index: Int?) async throws -> [User] {
        return responseToReturn ?? []
    }
    
    func searchUsers(with name: String) async throws -> [User] {
        return responseToReturnSearch?.users ?? []
    }
}
