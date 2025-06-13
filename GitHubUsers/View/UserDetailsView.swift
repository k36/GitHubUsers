//
//  UserDetailsView.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/13.
//

import Combine

protocol UserDetailsViewState: ObservableObject {
    var userInfo: UserInfo? { get }
    var repos: [UserRepositories] { get }
    var lastRepoId: Int? { get }
    var isLoadingRepos: Bool { get }
}

protocol UserDetailsViewListner {
    func loadGitRepos()
}

typealias UserInfoViewModelProtocol = UserDetailsViewState & UserDetailsViewListner
