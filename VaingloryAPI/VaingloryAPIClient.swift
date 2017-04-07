//
//  VaingloryAPIClient.swift
//  VaingloryAPI
//
//  Created by Jose Salavert on 18/03/2017.
//  Copyright © 2017 Jose Salavert. All rights reserved.
//

import Alamofire
import Foundation
import ObjectMapper
import Treasure

public enum Shard: String {
    case na
    case eu
    case sa
    case ea
    case sg
}

public enum DataCenter: String {
    case dc01
}

public enum VaingloryAPIError: Int {
    case unknown = 0
    case serviceDown = 1
    case invalidResponse = 2
    case invalidResource = 3
    
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case gone = 410
    case teapot = 418
    case tooManyRequests = 429
    case internalServerError = 500
    case serviceUnavailable = 503
}

public class VaingloryAPIClient: NSObject {
    fileprivate struct Constants {
        static let titleId = "semc-vainglory"
        static let accept = "application/vnd.api+json"
        static let acceptEncoding = "gzip"
    }
    fileprivate let authHeaders: HTTPHeaders
    fileprivate let anonHeaders: HTTPHeaders
    
    public init(apiKey: String) {
        authHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "X-TITLE-ID": Constants.titleId,
            "Content-Type": Constants.accept,
            "Accept": Constants.accept,
            "Accept-Encoding": Constants.acceptEncoding
        ]
        anonHeaders = [
            "X-TITLE-ID": Constants.titleId,
            "Accept": Constants.accept,
        ]
    }
}

// MARK: Player methods

public extension VaingloryAPIClient {
    func getPlayer(withId id: String, shard: Shard, callback: @escaping (PlayerResource?, VaingloryAPIError?) -> Void) {
        let url = Router(for: .player(id: id), shard: shard)
        
        request(url) { [weak self] parameters, error in
            guard let _ = self else { return }
            guard let parameters = parameters else {
                callback(nil, error)
                return
            }
            if let player: PlayerResource = Treasure(json: parameters).map() {
                callback(player, nil)
            } else {
                callback(nil, .invalidResource)
            }
        }
    }
    
    func getPlayer(withName name: String, shard: Shard, callback: @escaping (PlayerResource?, VaingloryAPIError?) -> Void) {
        let filters = RouterFilters().playerName(name)
        let url = Router(for: .players, shard: shard, filters: filters)
        
        request(url) { [weak self] parameters, error in
            guard let _ = self else { return }
            guard let parameters = parameters else {
                callback(nil, error)
                return
            }
            if let players: [PlayerResource] = Treasure(json: parameters).map(), let player = players.first {
                callback(player, nil)
            } else {
                callback(nil, .invalidResource)
            }
        }
    }
    
    func getPlayers(withNames names: [String], shard: Shard, callback: @escaping ([PlayerResource]?, VaingloryAPIError?) -> Void) {
        let filters = RouterFilters().playerNames(names)
        let url = Router(for: .players, shard: shard, filters: filters)
        
        request(url) { [weak self] parameters, error in
            guard let _ = self else { return }
            guard let parameters = parameters else {
                callback(nil, error)
                return
            }
            if let players: [PlayerResource] = Treasure(json: parameters).map() {
                callback(players, nil)
            } else {
                callback(nil, .invalidResource)
            }
        }
    }
}

// MARK: Match methods

public extension VaingloryAPIClient {
    func getMatch(withId id: String, shard: Shard, callback: @escaping (MatchResource?, VaingloryAPIError?) -> Void) {
        let url = Router(for: .match(id: id), shard: shard)

        request(url) { [weak self] parameters, error in
            guard let _ = self else { return }
            guard let parameters = parameters else {
                callback(nil, error)
                return
            }
            if let match: MatchResource = Treasure(json: parameters).map() {
                callback(match, nil)
            } else {
                callback(nil, .invalidResource)
            }
        }
    }
    
    func getMatches(shard: Shard, filters: RouterFilters?, callback: @escaping ([MatchResource]?, VaingloryAPIError?) -> Void) {
        let url = Router(for: .matches, shard: shard, filters: filters)
        
        request(url) { [weak self] parameters, error in
            guard let _ = self else { return }
            guard let parameters = parameters else {
                callback(nil, error)
                return
            }
            if let matches: [MatchResource] = Treasure(json: parameters).map() {
                callback(matches, nil)
            } else {
                callback(nil, .invalidResource)
            }
        }
    }
    
    func getSampleMatches(shard: Shard, callback: @escaping ([MatchResource]?, VaingloryAPIError?) -> Void) {
        let filters = RouterFilters().limit(1)
        let url = Router(for: .samples, shard: shard, filters: filters)
        
        request(url) { [weak self] parameters, error in
            guard let _ = self else { return }
            guard let parameters = parameters else {
                callback(nil, error)
                return
            }
            if let samples: [SampleResource] = Treasure(json: parameters).map() {
                samples.first?.getMatches(completionHandler: { matches in
                    callback(matches, nil)
                })
            } else {
                callback(nil, .invalidResource)
            }
        }
    }
    
    func getSamples(shard: Shard, filters: RouterFilters?, callback: @escaping ([SampleResource]?, VaingloryAPIError?) -> Void) {
        let url = Router(for: .samples, shard: shard, filters: filters)
        
        request(url) { [weak self] parameters, error in
            guard let _ = self else { return }
            guard let parameters = parameters else {
                callback(nil, error)
                return
            }
            if let samples: [SampleResource] = Treasure(json: parameters).map() {
                callback(samples, nil)
            } else {
                callback(nil, .invalidResource)
            }
        }
    }
}

// MARK: Telemetry methods

public extension VaingloryAPIClient {
    func getTelemetries(url: URLConvertible, callback: @escaping ([TelemetryResource]?, VaingloryAPIError?) -> Void) {
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: anonHeaders)
            .responseJSON { response in
                guard let json = response.result.value as? [Parameters] else {
                    callback(nil, .invalidResponse)
                    return
                }
                guard let telemetry = Mapper<TelemetryResource>().mapArray(JSONArray: json) else {
                    callback(nil, .invalidResource)
                    return
                }
                callback(telemetry, nil)
        }
    }
    
    func getTelemetries(resource: AssetResource, callback: @escaping ([TelemetryResource]?, VaingloryAPIError?) -> Void) {
        guard let url = resource.url else {
            callback(nil, .invalidResource)
            return
        }
        getTelemetries(url: url, callback: callback)
    }
}

private extension VaingloryAPIClient {
    func request(_ url: URLConvertible, parameters: Parameters? = [:], callback: @escaping (Parameters?, VaingloryAPIError?) -> Void) {
        Alamofire.request(url,
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding.queryString,
                          headers: authHeaders)
            .responseJSON { [weak self] response in
                guard let `self` = self else { return }
                if let error = self.handleResponseError(response) {
                    callback(nil, error)
                }
                if let json = response.result.value as? Parameters {
                    callback(json, nil)
                }
        }
    }
    
    func handleResponseError(_ response: DataResponse<Any>) -> VaingloryAPIError? {
        guard response.result.isSuccess else {
            return .serviceUnavailable
        }
        guard let _ = response.result.value else {
            return .invalidResponse
        }
        guard let statusCode = response.response?.statusCode else {
            return .unknown
        }
        return VaingloryAPIError(rawValue: statusCode) ?? nil
    }
}
