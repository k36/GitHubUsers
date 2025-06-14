//
//  UserDetailsViewModelTest.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/14.
//

import Foundation
import XCTest

@testable import GitHubUsers

final class UserDetailsViewModelTest: XCTestCase {
    
    var viewModel: UserDetailsViewModel!
    var mockDataProvider: MockUserDetailsViewDataProvider!
    
    override func setUp() {
        super.setUp()
        mockDataProvider = MockUserDetailsViewDataProvider()
    }
    
    func testLoadUserInfoAndRepoSuccess() async {
        mockDataProvider.responseToReturnUserInfo = Helper.loadLocalTestDataWithoutParsing("UserInfo", type: UserInfo.self)
        mockDataProvider.responseToReturnRepos = Helper.loadLocalTestDataWithoutParsing("UserRepo", type: [UserRepositories].self)
        viewModel = UserDetailsViewModel(loginUsername: "mojombo", dataProvider: mockDataProvider)
        
        await viewModel.loadUserInfo()
        await viewModel.loadGitRepos()
        
        XCTAssertEqual(viewModel.userInfo?.name, "Tom Preston-Werner")
        XCTAssertEqual(viewModel.userInfo?.login, "mojombo")
        XCTAssertEqual(viewModel.userInfo?.followers, 23918)
        XCTAssertEqual(viewModel.userInfo?.following, 11)
        XCTAssertEqual(viewModel.userInfo?.location, "San Francisco")
        XCTAssertEqual(viewModel.repos.count, 5)
    }
    
    func testLoadUserInfoFailed() async {
        mockDataProvider.responseToReturnUserInfo = Helper.loadLocalTestDataWithoutParsing("APIError", type: UserInfo.self)
        mockDataProvider.responseToReturnRepos = Helper.loadLocalTestDataWithoutParsing("UserRepo", type: [UserRepositories].self)
        viewModel = UserDetailsViewModel(loginUsername: "mojombo", dataProvider: mockDataProvider)
        
        await viewModel.loadUserInfo()
        await viewModel.loadGitRepos()
        
        XCTAssertNil(viewModel.userInfo?.name)
        XCTAssertNil(viewModel.userInfo?.login)
        XCTAssertNil(viewModel.userInfo?.followers)
        XCTAssertNil(viewModel.userInfo?.following)
        XCTAssertNil(viewModel.userInfo?.location)
        XCTAssertEqual(viewModel.repos.count, 5)
    }
    
    func testLoadRepoFailed() async {
        mockDataProvider.responseToReturnUserInfo = Helper.loadLocalTestDataWithoutParsing("UserInfo", type: UserInfo.self)
        mockDataProvider.responseToReturnRepos = Helper.loadLocalTestDataWithoutParsing("APIError", type: [UserRepositories].self)
        viewModel = UserDetailsViewModel(loginUsername: "mojombo", dataProvider: mockDataProvider)
        
        await viewModel.loadUserInfo()
        await viewModel.loadGitRepos()
        
        XCTAssertEqual(viewModel.userInfo?.name, "Tom Preston-Werner")
        XCTAssertEqual(viewModel.userInfo?.login, "mojombo")
        XCTAssertEqual(viewModel.userInfo?.followers, 23918)
        XCTAssertEqual(viewModel.userInfo?.following, 11)
        XCTAssertEqual(viewModel.repos.count, 0)
    }
    
    func testLoadRepoWithPaginationSuccess() async {
        mockDataProvider.responseToReturnRepos = Helper.loadLocalTestDataWithoutParsing("UserRepo", type: [UserRepositories].self)
        viewModel = UserDetailsViewModel(loginUsername: "mojombo", dataProvider: mockDataProvider)
        
        await viewModel.loadGitRepos()
        
        XCTAssertEqual(viewModel.repos.count, 5)
        
        // Load more
        await viewModel.loadGitRepos()
        XCTAssertEqual(viewModel.repos.count, 10)
    }
    
    func testLoadRepoWithPaginationFailure() async {
        mockDataProvider.responseToReturnRepos = Helper.loadLocalTestDataWithoutParsing("UserRepo", type: [UserRepositories].self)
        viewModel = UserDetailsViewModel(loginUsername: "mojombo", dataProvider: mockDataProvider)
        
        await viewModel.loadGitRepos()
        XCTAssertEqual(viewModel.repos.count, 5)
        
        // Failure in next page
        mockDataProvider.responseToReturnRepos = Helper.loadLocalTestDataWithoutParsing("APIError", type: [UserRepositories].self)
        
        await viewModel.loadGitRepos()
        XCTAssertEqual(viewModel.repos.count, 5)
    }
    
    func testLastRepoId() async {
        mockDataProvider.responseToReturnRepos = Helper.loadLocalTestDataWithoutParsing("UserRepo", type: [UserRepositories].self)
        viewModel = UserDetailsViewModel(loginUsername: "mojombo", dataProvider: mockDataProvider)
        
        await viewModel.loadGitRepos()
        
        XCTAssertEqual(viewModel.lastRepoId, 444244)
    }
}
