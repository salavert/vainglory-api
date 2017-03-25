//
//  PlayerResponseModel.swift
//  VaingloryAPI
//
//  Created by Jose Salavert on 19/03/2017.
//  Copyright © 2017 Jose Salavert. All rights reserved.
//

import Foundation
import ObjectMapper

class PlayerResponseModel: Mappable {
    var id: String?
    var name: String?
    var level: Int?
    var playedRanked: Int?
    var wins: Int?
    var xp: Int?
    var played: Int?
    var lossStreak: Int?
    var winStreak: Int?
    var lifetimeGold: Float?
    var createdAt: Date?
    var shard: Shard?

    var description: String {
        return "[PlayerResponseModel] id: \(id), name: \(name), lossStreak: \(lossStreak), winStreak: \(winStreak), lifetimeGold: \(lifetimeGold)"
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["attributes.name"]
        level <- map["attributes.stats.level"]
        playedRanked <- map["attributes.stats.played_ranked"]
        wins <- map["attributes.stats.wins"]
        xp <- map["attributes.stats.xp"]
        played <- map["attributes.stats.played"]
        lossStreak <- map["attributes.stats.lossStreak"]
        winStreak <- map["attributes.stats.winStreak"]
        lifetimeGold <- map["attributes.stats.lifetimeGold"]
        createdAt <- (map["attributes.createdAt"], DateTransform())
        shard = Shard(rawValue: map["attributes.shardId"].currentValue as? String ?? "na")
    }
}
