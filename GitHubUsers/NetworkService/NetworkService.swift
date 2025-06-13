//
//  NetworkService.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/13.
//

import Foundation

final class NetworkManager {
    
    private enum Constant {
        static let token = "" // TODO: Add token here
        static let baseUrl = "https://api.github.com/"
    }
    
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(
        endpoint: String,
        method: NetworkRequestType = .get,
        parameters: [String : Any] = [:],
        responseType: T.Type
    ) async throws -> T {
        guard let url = URL(string: "\(Constant.baseUrl + endpoint)") else {
            throw NetworkError.invalidURL
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        guard let componentsUrl = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: componentsUrl)
        request.httpMethod = method.rawValue
        if Constant.token.count > 0 {
            request.addValue("Bearer \(Constant.token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

enum NetworkRequestType: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server."
        case .httpError(let code):
            return "HTTP error with status code: \(code)."
        case .decodingError(let error):
            return "Failed to decode JSON: \(error.localizedDescription)"
        }
    }
}
