//
//  LinkCoordinator.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/14.
//

import Combine
import SwiftUI

final class LinkCoordinator: ObservableObject {
    let didTapURL = PassthroughSubject<String?, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        didTapURL
            .compactMap { $0 }
            .compactMap { URL(string: $0) }
            .sink { url in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            .store(in: &cancellables)
    }
}
