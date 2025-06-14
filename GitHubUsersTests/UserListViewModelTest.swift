//
//  UserListViewModelTest.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/14.
//

import Foundation
import XCTest

@testable import GitHubUsers
import Combine

final class UserListViewModelTest: XCTestCase {
    
    var viewModel: UserListViewModel!
    var mockDataProvider: MockUserListViewDataProvider!
    
    override func setUp() {
        super.setUp()
        mockDataProvider = MockUserListViewDataProvider()
    }
    
    func testLoadGitHubUsersSuccess() async {
        mockDataProvider.responseToReturn = Helper.loadLocalTestDataWithoutParsing("UserList", type: [User].self)
        viewModel = UserListViewModel(dataProvider: mockDataProvider)
        
        await viewModel.loadGitHubUsers()
        
        XCTAssertEqual(viewModel.users.count, 5)
    }
    
    func testLoadGitHubUsersFailure() async {
        mockDataProvider.responseToReturn = Helper.loadLocalTestDataWithoutParsing("APIError", type: [User].self)
        viewModel = UserListViewModel(dataProvider: mockDataProvider)
        
        await viewModel.loadGitHubUsers()
        
        XCTAssertEqual(viewModel.users.count, 0)
    }
    
    func testPaginationSuccess() async {
        mockDataProvider.responseToReturn = Helper.loadLocalTestDataWithoutParsing("UserList", type: [User].self)
        viewModel = UserListViewModel(dataProvider: mockDataProvider)
        
        await viewModel.loadGitHubUsers()
        
        XCTAssertEqual(viewModel.users.count, 5)
        
        await viewModel.loadGitHubUsers()
        
        XCTAssertEqual(viewModel.users.count, 10)
    }
    
    func testPaginationFailure() async {
        mockDataProvider.responseToReturn = Helper.loadLocalTestDataWithoutParsing("UserList", type: [User].self)
        viewModel = UserListViewModel(dataProvider: mockDataProvider)
        
        await viewModel.loadGitHubUsers()
        
        XCTAssertEqual(viewModel.users.count, 5)
        
        mockDataProvider.responseToReturn = Helper.loadLocalTestDataWithoutParsing("APIError", type: [User].self)
        
        await viewModel.loadGitHubUsers()
        
        XCTAssertEqual(viewModel.users.count, 5)
    }
    
    func testSearchUsersSuccess() async {
        mockDataProvider.responseToReturn = Helper.loadLocalTestDataWithoutParsing("UserList", type: [User].self)
        viewModel = UserListViewModel(dataProvider: mockDataProvider)
        
        await viewModel.loadGitHubUsers()
        
        XCTAssertEqual(viewModel.users.count, 5)
        
        self.mockDataProvider.responseToReturnSearch = Helper.loadLocalTestDataWithoutParsing("UserSearch", type: UsersSearch.self)
        self.viewModel.searchUsers(with: "keyur")
        
        var cancellable: AnyCancellable?
        let expectation = expectation(description: "Wait for users.count == 2")
        
        cancellable = viewModel.$users
            .sink { users in
                if users.count == 2 {
                    expectation.fulfill()
                    cancellable?.cancel()
                }
            }
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testSearchUsersFailure() async {
        mockDataProvider.responseToReturn = Helper.loadLocalTestDataWithoutParsing("UserList", type: [User].self)
        viewModel = UserListViewModel(dataProvider: mockDataProvider)
        
        await viewModel.loadGitHubUsers()
        
        XCTAssertEqual(viewModel.users.count, 5)
        
        mockDataProvider.responseToReturnSearch = Helper.loadLocalTestDataWithoutParsing("APIError", type: UsersSearch.self)
        viewModel.searchUsers(with: "keyur")
        
        var cancellable: AnyCancellable?
        let expectation = expectation(description: "Wait for users.count == 0")
        
        cancellable = viewModel.$users
            .sink { users in
                if users.count == 0 {
                    expectation.fulfill()
                    cancellable?.cancel()
                }
            }
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testSearchUsersPaginationWhileSearching() async {
        mockDataProvider.responseToReturn = Helper.loadLocalTestDataWithoutParsing("UserList", type: [User].self)
        viewModel = UserListViewModel(dataProvider: mockDataProvider)
        
        await viewModel.loadGitHubUsers()
        
        XCTAssertEqual(viewModel.users.count, 5)
        
        mockDataProvider.responseToReturnSearch = Helper.loadLocalTestDataWithoutParsing("UserSearch", type: UsersSearch.self)
        viewModel.searchUsers(with: "keyur")
        
        // Should be ignored due to isSearching = true
        await viewModel.loadGitHubUsers()
        
        XCTAssertEqual(viewModel.users.count, 5)
    }
    
    func testDismissSearchUsersRestoresUserList() async {
        mockDataProvider.responseToReturn = Helper.loadLocalTestDataWithoutParsing("UserList", type: [User].self)
        viewModel = UserListViewModel(dataProvider: mockDataProvider)
        
        await viewModel.loadGitHubUsers()
        
        XCTAssertEqual(viewModel.users.count, 5)
        
        mockDataProvider.responseToReturnSearch = Helper.loadLocalTestDataWithoutParsing("UserSearch", type: UsersSearch.self)
        viewModel.searchUsers(with: "keyur")
        
        var cancellable: AnyCancellable?
        let expectation = expectation(description: "Eventaully users.count should be 5")
        
        cancellable = viewModel.$users
            .sink { [weak self] users in
                if users.count == 2 {
                    self?.viewModel.dismissSearchUsers()
                    XCTAssertEqual(self?.viewModel.users.count, 5)
                    expectation.fulfill()
                    cancellable?.cancel()
                }
            }
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testLastUserIdValue() async {
        mockDataProvider.responseToReturn = Helper.loadLocalTestDataWithoutParsing("UserList", type: [User].self)
        viewModel = UserListViewModel(dataProvider: mockDataProvider)
        
        await viewModel.loadGitHubUsers()
        
        XCTAssertEqual(viewModel.lastUserId, 54859)
    }
}
