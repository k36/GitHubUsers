//
//  UserListView.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/13.
//

import Combine

protocol UserListViewState: ObservableObject {
    var users: [User] { get }
    var lastUserId: Int? { get }
    var isLoading: Bool { get }
}

protocol UserListViewListner {
    func loadGitHubUsers()
    func searchUsers(with name: String)
    func dismissSearchUsers()
}

typealias UserListViewModelProtocol = UserListViewState & UserListViewListner
