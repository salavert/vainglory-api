//
//  MatchResource.swift
//  Pods
//
//  Created by Jose Salavert on 26/03/2017.
//
//

import Foundation
import Mapper
import Treasure

public struct MatchResource: Resource {

    public let id: String
    public let type: String
    
    let patchVersion: String?
    let shardId: String?
    let titleId: String?
    let gameMode: String?
    let duration: Int?
    let createdAt: String?
    let queue: String?
    let endGameReason: String?
    
    let rosters: [RosterResource]?
    let asset: [AssetResource]?
    
    public init(map: Mapper) throws {
        id = try map.from(Key.id)
        type = try map.from(Key.type)
        
        patchVersion = try? map.from(Key.attributes("patchVersion"))
        shardId = try? map.from(Key.attributes("shardId"))
        titleId = try? map.from(Key.attributes("titleId"))
        gameMode = try? map.from(Key.attributes("gameMode"))
        duration = try? map.from(Key.attributes("duration"))
        createdAt = try? map.from(Key.attributes("createdAt"))

        queue = try? map.from(Key.attributes("stats.queue"))
        endGameReason = try? map.from(Key.attributes("stats.endGameReason"))
        
        let rostersRelationship: ToManyRelationship? = try? map.from(Key.relationships("rosters"))
        rosters = try? map.from(rostersRelationship)

        let assetRelationship: ToManyRelationship? = try? map.from(Key.relationships("assets"))
        asset = try? map.from(assetRelationship)
    }
}
