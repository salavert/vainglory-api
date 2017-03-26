//
//  VaingloryAPIClient.swift
//  VaingloryAPI
//
//  Created by Jose Salavert on 18/03/2017.
//  Copyright © 2017 Jose Salavert. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import Foundation
import Treasure

public enum Shard: String {
    case na
    case eu
    case sa
    case ea
    case sg
}

public class VaingloryAPIClient: NSObject {
    
    fileprivate enum Router: URLConvertible {
        case player(id: String, shard: Shard)
        case players(shard: Shard)
        case match(id: String, shard: Shard)
        case matches(shard: Shard)
        
        static let baseURLString = "https://api.dc01.gamelockerapp.com"
        
        var path: String {
            switch self {
            case .player(let id, let shard):
                return "/shards/\(shard)/players/\(id)"
            case .players(let shard):
                return "/shards/\(shard)/players"
            case .match(let id, let shard):
                return "/shards/\(shard)/matches/\(id)"
            case .matches(let shard):
                return "/shards/\(shard)/matches"
            }
        }
        
        func asURL() throws -> URL {
            let baseUrl = try Router.baseURLString.asURL()
            return URL(string: path, relativeTo: baseUrl)!
        }
    }

    fileprivate let headers: HTTPHeaders
    
    public init(apiKey: String) {
        headers = [
            "Authorization": "Bearer \(apiKey)",
            "X-TITLE-ID": "semc-vainglory",
            "Content-Type": "application/vnd.api+json",
            "Accept": "application/vnd.api+json",
            "Accept-Encoding": "gzip"
        ]
    }
}

public extension VaingloryAPIClient {
    func getPlayer(withId id: String, shard: Shard, callback: @escaping (PlayerResource?, Error?) -> Void) {
        request(Router.player(id: id, shard: shard)).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let player: PlayerResource? = Treasure(json: json).map()
                callback(player, nil)
            }
        }
    }
    
    func getPlayer(withName name: String, shard: Shard, callback: @escaping (PlayerResource?, Error?) -> Void) {
        let parameters = [
            "filter": ["playerNames": name]
        ]
        request(Router.players(shard: shard), parameters: parameters).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let players: [PlayerResource]? = Treasure(json: json).map()
                callback(players?.first, nil)
            }
        }
    }
    
    func getPlayers(withNames names: [String], shard: Shard, callback: @escaping ([PlayerResource]?, Error?) -> Void) {
        let parameters = [
            "filter": ["playerNames": names.joined(separator: ",")]
        ]
        request(Router.players(shard: shard), parameters: parameters).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let players: [PlayerResource]? = Treasure(json: json).map()
                callback(players, nil)
            }
        }
    }
    
    func getMatch(withId id: String, shard: Shard, callback: @escaping (MatchResource?, Error?) -> Void) {
        request(Router.match(id: id, shard: shard)).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let match: MatchResource? = Treasure(json: json).map()
                callback(match, nil)
            }
        }
    }
    
    func getMatches(shard: Shard, callback: @escaping ([MatchResource]?, Error?) -> Void) {
        let parameters: [String : Any] = [
            "sort": "createdAt",
            "page": ["limit": 2],
            "filter": [
                "createdAt-start": "2017-03-10T13:25:30Z",
                "playerNames": "Salavert"]
        ]
        request(Router.matches(shard: shard), parameters: parameters).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let matches: [MatchResource]? = Treasure(json: json).map()
                callback(matches, nil)
            }
        }
    }
}

private extension VaingloryAPIClient {
    func request(_ url: URLConvertible, parameters: Parameters? = [:]) -> DataRequest {
        return Alamofire.request(url,
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding.queryString,
                                 headers: headers)
    }
}
