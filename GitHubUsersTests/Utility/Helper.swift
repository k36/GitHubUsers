//
//  Helper.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/14.
//

import Foundation

final class Helper {
    static func loadLocalTestDataWithoutParsing<T: Decodable>(_ fileName: String, type: T.Type) -> T? {
        let bundle = Bundle(for: Helper.self)
        let path = bundle.path(forResource: fileName, ofType: "json")!
        let url = URL(fileURLWithPath: path)
        do {
            return try JSONDecoder().decode(T.self, from: Data(contentsOf: url))
        } catch {
            return nil
        }
    }
}
