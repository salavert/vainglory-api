//
//  ParticipantResource.swift
//  Pods
//
//  Created by Jose Salavert on 26/03/2017.
//
//

import Foundation
import Mapper
import Treasure

public struct ParticipantResource: Resource {
    
    public let id: String
    public let type: String

    let actor: String?
    let assists: Int?
    let crystalMineCaptures: Int?
    let deaths: Int?
    let farm: Int?
    let firstAfkTime: Bool
    let goldMineCaptures: Int?
    let itemGrants: [String: Any]?
    let itemSells: [String: Any]?
    let itemUses: [String: Any]?
    let items: [String]?
    let jungleKills: Int?
    let karmaLevel: Int?
    let kills: Int?
    let krakenCaptures: Int?
    let level: Int?
    let minionKills: Int?
    let nonJungleMinionKills: Int?
    let skillTier: Int?
    let skinKey: String?
    let turretCaptures: Int?
    let wentAfk: Bool?
    let winner: Bool?
    
    let player: PlayerResource?
    
    public init(map: Mapper) throws {
        id = try map.from(Key.id)
        type = try map.from(Key.type)
        
        actor = try? map.from(Key.attributes("actor"))
        
        assists = try? map.from(Key.attributes("stats.assists"))
        crystalMineCaptures = try? map.from(Key.attributes("stats.crystalMineCaptures"))
        deaths = try? map.from(Key.attributes("stats.deaths"))
        farm = try? map.from(Key.attributes("stats.farm"))
        firstAfkTime = try map.from(Key.attributes("stats.firstAfkTime"))
        goldMineCaptures = try? map.from(Key.attributes("stats.goldMineCaptures"))
        itemGrants = try? map.from(Key.attributes("stats.itemGrants"))
        itemSells = try? map.from(Key.attributes("stats.itemSells"))
        itemUses = try? map.from(Key.attributes("stats.itemUses"))
        items = try? map.from(Key.attributes("stats.items"))
        jungleKills = try? map.from(Key.attributes("stats.jungleKills"))
        karmaLevel = try? map.from(Key.attributes("stats.karmaLevel"))
        kills = try? map.from(Key.attributes("stats.kills"))
        krakenCaptures = try? map.from(Key.attributes("stats.krakenCaptures"))
        level = try? map.from(Key.attributes("stats.level"))
        minionKills = try? map.from(Key.attributes("stats.minionKills"))
        nonJungleMinionKills = try? map.from(Key.attributes("stats.nonJungleMinionKills"))
        skillTier = try? map.from(Key.attributes("stats.skillTier"))
        skinKey = try? map.from(Key.attributes("stats.skinKey"))
        turretCaptures = try? map.from(Key.attributes("stats.turretCaptures"))
        wentAfk = try? map.from(Key.attributes("stats.wentAfk"))
        winner = try? map.from(Key.attributes("stats.winner"))
        
        let playerRelationship: ToOneRelationship? = try? map.from(Key.relationships("player"))
        player = try? map.from(playerRelationship)
    }
}
