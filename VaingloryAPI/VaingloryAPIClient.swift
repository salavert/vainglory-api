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
        
        request(endpointUrl).responseObject(keyPath: "data") { (response: DataResponse<PlayerResponseModel>) in
            print(response.result.value?.description)
        }
    }
    
    func getPlayer(withName name: String) {
        let endpointUrl = URL(string: "players", relativeTo: baseUrl)!
        let parameters = [
            "filter": ["playerNames": name]
        ]
        request(endpointUrl).responseArray(keyPath: "data") { (response: DataResponse<[PlayerResponseModel]>) in
            if let player = response.result.value?.first {
                print(player.description)
            }
        }
    }
    
    func getPlayers(withNames names: String ...) {
        let endpointUrl = URL(string: "players", relativeTo: baseUrl)!
        let parameters = [
            "filter": ["playerNames": names.joined(separator: ",")]
        ]
        request(endpointUrl).responseArray(keyPath: "data") { (response: DataResponse<[PlayerResponseModel]>) in
            if let players = response.result.value {
                for player in players {
                    print(player.description)
                }
            }
        }
    }
    
    func getMatch(withId id: String) {
        let endpointUrl = URL(string: "matches/\(id)", relativeTo: baseUrl)!
//        request(endpointUrl).responseObject { [weak self] (response: DataResponse<MatchResponseModel>) in
//            if let match = response.result.value {
//                print("MATCH \(match.description)")
//            }
//        }
        request(endpointUrl).responseJSON { [weak self] (response: DataResponse<Any>) in
            if let json = response.result.value {
                
                print("MATCH \(json)")
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
        request(endpointUrl, parameters: parameters).responseJSON { [weak self] (response: DataResponse<Any>) in
            if let matches = response.result.value {
//                print("MATCHES \(matches.count)")
            }
        }
    }
}

private extension VaingloryAPIClient {
    func request(_ url: URL, parameters: Parameters? = [:]) -> DataRequest {
        return Alamofire.request(url,
                                 method: .get,
                                 parameters: parameters,
                                 encoding: JSONEncoding.default,
                                 headers: headers)
    }
}
