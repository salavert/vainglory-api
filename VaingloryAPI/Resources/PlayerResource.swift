//
//  PlayerResource.swift
//  Pods
//
//  Created by Jose Salavert on 26/03/2017.
//
//

import Foundation
import Mapper
import Treasure

public struct PlayerResource: Resource {
    
    public let id: String
    public let type: String
    
    public let shardId: String?
    public let titleId: String?
    public let name: String?
    public let createdAt: String?
    
    public let played: Int?
    public let playedRanked: Int?
    public let level: Int?
    public let xp: Int?
    public let lossStreak: Int?
    public let wins: Int?
    public let winStreak: Int?
    public let lifetimeGold: Float?
    
    //var shard: Shard?

    public init(map: Mapper) throws {
        id = try map.from(Key.id)
        type = try map.from(Key.type)
        
        shardId  = try map.from(Key.attributes("shardId"))
        titleId  = try map.from(Key.attributes("titleId"))
        name = try? map.from(Key.attributes("name"))
        createdAt = try? map.from(Key.attributes("createdAt"))
        
        played = try? map.from(Key.attributes("stats.played"))
        playedRanked = try? map.from(Key.attributes("stats.played_ranked"))
        level = try? map.from(Key.attributes("stats.level"))
        xp = try? map.from(Key.attributes("stats.xp"))
        lossStreak = try? map.from(Key.attributes("stats.lossStreak"))
        wins = try? map.from(Key.attributes("stats.wins"))
        winStreak = try? map.from(Key.attributes("stats.winStreak"))
        lifetimeGold = try? map.from(Key.attributes("stats.lifetimeGold"))
    }
}
