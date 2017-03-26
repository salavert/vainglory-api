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
    
    let shardId: String?
    let titleId: String?
    let name: String?
    let createdAt: String?
    
    let played: Int?
    let playedRanked: Int?
    let level: Int?
    let xp: Int?
    let lossStreak: Int?
    let wins: Int?
    let winStreak: Int?
    let lifetimeGold: Float?
    
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
