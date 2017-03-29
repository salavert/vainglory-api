//
//  Router.swift
//  Pods
//
//  Created by Jose Salavert on 28/03/2017.
//
//

import Alamofire
import Foundation

public enum ResourceType {
    case player(id: String)
    case players
    case match(id: String)
    case matches
    
    var path: String {
        switch self {
        case .player(let id):
            return "players/\(id)"
        case .players:
            return "players"
        case .match(let id):
            return "matches/\(id)"
        case .matches:
            return "matches"
        }
    }
}

public class Router: URLConvertible {

    fileprivate var urlComponents: URLComponents
    
    public init(for resourceType: ResourceType, shard: Shard, filters: RouterFilters? = nil, dataCenter: DataCenter = .dc01) {
        urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.\(dataCenter).gamelockerapp.com"
        urlComponents.path = "/shards/\(shard)/\(resourceType.path)"
        urlComponents.queryItems = filters?.asQueryItems()
    }
    
    public func asURL() throws -> URL {
        return try urlComponents.asURL()
    }
}

public class RouterFilters {

    fileprivate var filters: [URLQueryItem] = []

    fileprivate struct Constants {
        struct keys {
            static let limit = "page[limit]"
            static let offset = "page[offset]"
            static let sort = "sort"
            static let createdAtStart = "filter[createdAt-start]"
            static let createdAtEnd = "filter[createdAt-end]"
            static let playerNames = "filter[playerNames]"
            static let playerIds = "filter[playerIds]"
            static let teamNames = "filter[teamNames]"
            static let gameMode = "filter[gameMode]"
        }
    }
    
    public init() {
        
    }
    
    public func asQueryItems() -> [URLQueryItem] {
        return filters
    }
    
    public func offset(_ offset: Int) -> Self {
        filters.append(URLQueryItem(name: Constants.keys.offset, value: String(offset)))
        return self
    }
    
    public func limit(_ limit: Int) -> Self {
        filters.append(URLQueryItem(name: Constants.keys.limit, value: String(limit)))
        return self
    }
    
    public func sortField(_ sortField: String) -> Self {
        filters.append(URLQueryItem(name: Constants.keys.sort, value: sortField))
        return self
    }
    
    public func playerNames(_ playerNames: [String]) -> Self {
        filters.append(URLQueryItem(name: Constants.keys.playerNames, value: joined(playerNames)))
        return self
    }
    
    public func playerName(_ playerName: String) -> Self {
        return playerNames([playerName])
    }
    
    public func teamNames(_ teamNames: [String]) -> Self {
        filters.append(URLQueryItem(name: Constants.keys.teamNames, value: joined(teamNames)))
        return self
    }
    
    public func createdAtStart(_ date: String) -> Self {
        filters.append(URLQueryItem(name: Constants.keys.createdAtStart, value: date))
        return self
    }
    
    public func createdAtEnd(_ date: String) -> Self {
        filters.append(URLQueryItem(name: Constants.keys.createdAtEnd, value: date))
        return self
    }
    
    public func gameMode(_ gameMode: String) -> Self {
        filters.append(URLQueryItem(name: Constants.keys.gameMode, value: gameMode))
        return self
    }
    
    public func gameModes(_ gameModes: [String]) -> Self {
        return gameMode(joined(gameModes))
    }
    
    public func playerIds(_ playerIds: [String]) -> Self {
        filters.append(URLQueryItem(name: Constants.keys.createdAtEnd, value: joined(playerIds)))
        return self
    }
}

private extension RouterFilters {
    func joined(_ subject: [String]) -> String {
        return subject.joined(separator: ",")
    }
}
