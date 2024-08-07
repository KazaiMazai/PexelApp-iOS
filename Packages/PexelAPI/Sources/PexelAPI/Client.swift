// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct Client {
    let apiKey: String?
    let version: Version
    let baseURL: URL

    public init(apiKey: String? = nil, baseURL: URL, version: Version) {
        self.apiKey = apiKey
        self.version = version
        self.baseURL = baseURL
    }

    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }()

    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
}

extension Client {
    public enum Version: String {
        // swiftlint:disable:next identifier_name
        case v1

        var path: String {
            rawValue
        }
    }
}

extension Client {

    func defaultHandler<Result: Decodable>(data: Data, response: URLResponse) throws -> Result {

        guard let response = response as? HTTPURLResponse else {
            throw Errors.emptyResponse
        }

        guard response.statusCode != 401 else {
            throw Errors.unauthorrized
        }

        guard response.statusCode == 200 else {
            guard let errorReponse = try? decoder.decode(Responses.ErrorResponse.self, from: data)
            else {
                throw Errors.unknownServerError
            }

            throw Errors.serverError(message: errorReponse.message)
        }

        do {
            return try decoder.decode(Result.self, from: data)
        } catch {
            throw Errors.unknownResponseFormat
        }
    }
}

extension Client {
    func dataRequest<Result: Decodable>(urlRequest: URLRequest) -> Request<Result> {
        Request(urlRequest: urlRequest, type: .data(handler: defaultHandler))
    }
}

extension Client {
    func get(_ baseURL: URL,
             to path: String,
             with params: [URLQueryItem] = []) throws -> URLRequest {

        var request = try urlRequest(baseURL, path: path, with: params)
        request.httpMethod = "GET"
        return request
    }
}

private extension Client {
    func urlRequest(_ baseURL: URL,
                    path: String,
                    with params: [URLQueryItem] = []) throws -> URLRequest {

        var url = baseURL
        url.appendPathComponent(path)
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw Errors.invalidURL(url.absoluteURL)
        }

        components.queryItems = params
        guard let componentsURL = components.url else {
            throw Errors.invalidURL(url.absoluteURL)
        }

        var request = URLRequest(url: componentsURL)
        guard let apiKey else {
            return request
        }
        request.addValue("\(apiKey)", forHTTPHeaderField: "Authorization")
        return request
    }
}
