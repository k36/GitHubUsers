//
//  UserListViewDataProvider.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/13.
//

protocol UserListViewDataProviding {
    var hasLoadedAllUsers: Bool { get }
    func loadGitHubUsers(index: Int?) async throws -> [User]
    func searchUsers(with name: String) async throws -> [User]
}

final class UserListViewDataProvider: UserListViewDataProviding {
    
    private enum Constant {
        static let keySince = "since"
        static let keyPerPageLimit = "per_page"
        static let keySearchQuery = "q"
        static let perPageLimit = 30
        static let perPageLimitForSearch = 100
    }
    
    var hasLoadedAllUsers: Bool = false
    
    func loadGitHubUsers(index: Int?) async throws -> [User] {
        guard !hasLoadedAllUsers else { return [] }
        var parameters: [String : Any] = [Constant.keyPerPageLimit : Constant.perPageLimit]
        if let index {
            parameters[Constant.keySince] = index
        }
        let users = try await NetworkManager.shared.request(endpoint: "users", parameters: parameters, responseType: [User].self)
        self.hasLoadedAllUsers = users.count < Constant.perPageLimit
        return users
    }
    
    func searchUsers(with name: String) async throws -> [User] {
        var parameters: [String : Any] = [Constant.keyPerPageLimit : Constant.perPageLimitForSearch]
        parameters[Constant.keySearchQuery] = name
        return try await  NetworkManager.shared.request(endpoint: "search/users", parameters: parameters, responseType: UsersSearch.self).users ?? []
    }
}
