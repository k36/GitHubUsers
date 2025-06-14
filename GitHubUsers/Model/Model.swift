//
//  Model.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/13.
//

import Foundation

// MARK: - User
struct User: Codable, Hashable, Identifiable {
    let login: String?
    let id: Int?
    let avatarURL: String?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
    }
}

// MARK: - UserInfo
struct UserInfo: Codable {
    let login: String?
    let id: Int?
    let htmlURL: String?
    let name: String?
    let avatarURL: String?
    let location: String?
    let followers: Int?
    let following: Int?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case htmlURL = "html_url"
        case avatarURL = "avatar_url"
        case name, location
        case followers, following
    }
}

// MARK: - UserRepositories
struct UserRepositories: Codable, Hashable {
    let id: Int?
    let name: String?
    let htmlURL: String?
    let description: String?
    let language: String?
    let starCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case htmlURL = "html_url"
        case description
        case language
        case starCount = "stargazers_count"
    }
}

// MARK: - UsersSearch
struct UsersSearch: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let users: [User]?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case users = "items"
    }
}
