//
//  VaingloryAPIClient.swift
//  VaingloryAPI
//
//  Created by Jose Salavert on 18/03/2017.
//  Copyright © 2017 Jose Salavert. All rights reserved.
//

import Alamofire
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

public enum DataCenter: String {
    case dc01
}

public class VaingloryAPIClient: NSObject {
    
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
        let url = Router(for: .player(id: id), shard: shard)
        
        request(url).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let player: PlayerResource? = Treasure(json: json).map()
                callback(player, nil)
            }
        }
    }
    
    func getPlayer(withName name: String, shard: Shard, callback: @escaping (PlayerResource?, Error?) -> Void) {
        let filters = RouterFilters().playerName(name)
        let url = Router(for: .players, shard: shard, filters: filters)
        
        request(url).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let players: [PlayerResource]? = Treasure(json: json).map()
                callback(players?.first, nil)
            }
        }
    }
    
    func getPlayers(withNames names: [String], shard: Shard, callback: @escaping ([PlayerResource]?, Error?) -> Void) {
        let filters = RouterFilters().playerNames(names)
        let url = Router(for: .players, shard: shard, filters: filters)
        
        request(url).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let players: [PlayerResource]? = Treasure(json: json).map()
                callback(players, nil)
            }
        }
    }
    
    func getMatch(withId id: String, shard: Shard, callback: @escaping (MatchResource?, Error?) -> Void) {
        let url = Router(for: .match(id: id), shard: shard)

        request(url).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let match: MatchResource? = Treasure(json: json).map()
                callback(match, nil)
            }
        }
    }
    
    func getMatches(shard: Shard, filters: RouterFilters?, callback: @escaping ([MatchResource]?, Error?) -> Void) {
        let url = Router(for: .matches, shard: shard, filters: filters)
        
        request(url).responseJSON { response in
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
