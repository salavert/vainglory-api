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

public enum DataCenter: String {
    case dc01
}

public enum Shard: String {
    case na
    case eu
    case sa
    case ea
    case sg
}

public enum BackendError: Error {
    case network(error: Error)
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}

public enum Entities: String {
    case unknown
    case player
    case participant
    case roster
    case match
}

public class VaingloryAPIClient: NSObject {
    
    
    
    fileprivate let baseUrl: URL
    fileprivate let headers: HTTPHeaders
    
    public init(dataCenter: DataCenter, shard: Shard, apiKey: String) {
        baseUrl = URL(string: "https://api.\(dataCenter).gamelockerapp.com/shards/\(shard)/")!
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
    func getPlayer(withId id: String) {
        let endpointUrl = URL(string: "players/\(id)", relativeTo: baseUrl)!
        request(endpointUrl).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let player: PlayerResource? = Treasure(json: json).map()
                print(player)
            }
        }
    }
    
    func getPlayer(withName name: String) {
        let endpointUrl = URL(string: "players", relativeTo: baseUrl)!
        let parameters = [
            "filter": ["playerNames": name]
        ]
        request(endpointUrl, parameters: parameters).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let players: [PlayerResource]? = Treasure(json: json).map()
                let player = players?.first
                print(player)
            }
        }
    }
    
    func getPlayers(withNames names: String ...) {
        let endpointUrl = URL(string: "players", relativeTo: baseUrl)!
        let parameters = [
            "filter": ["playerNames": names.joined(separator: ",")]
        ]
        request(endpointUrl, parameters: parameters).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let players: [PlayerResource]? = Treasure(json: json).map()
                print(players)
            }
        }

    }
    
    func getMatch(withId id: String) {
        let endpointUrl = URL(string: "matches/\(id)", relativeTo: baseUrl)!
        request(endpointUrl).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let match: MatchResource? = Treasure(json: json).map()
                print(match)
            }
        }
    }
    
    func getMatches() {
        let endpointUrl = URL(string: "matches", relativeTo: baseUrl)!
        let parameters: [String : Any] = [
            "sort": "createdAt",
            "page": ["limit": 2],
            "filter": ["createdAt-start": "2017-02-27T13:25:30Z",
                       "playerNames": "Salavert"]
        ]
        request(endpointUrl, parameters: parameters).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                let matches: [MatchResource]? = Treasure(json: json).map()
                print(matches)
            }
        }
    }
}

private extension VaingloryAPIClient {
    func request(_ url: URL, parameters: Parameters? = [:]) -> DataRequest {
        return Alamofire.request(url,
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding.queryString,
                                 headers: headers)
    }
}
