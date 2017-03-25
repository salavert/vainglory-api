//
//  MatchResponseModel.swift
//  VaingloryAPI
//
//  Created by Jose Salavert on 20/03/2017.
//  Copyright © 2017 Jose Salavert. All rights reserved.
//

import Foundation
import ObjectMapper

class MatchResponseModel: Mappable {
    var id: String?
    var createdAt: Date?
    var duration: Int?
    var gameMode: String?
    var patchVersion: String?
    var endGameReason: String?
    var queue: String?
    var shard: Shard?
    
    var rosters: [RosterResponseModel] = []
    
    var rostersRelationships: [String] = []
    
    var description: String {
        return "[MatchResponseModel] id: \(id), rosters: \(rosters.count)"
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["data.id"]
        createdAt <- (map["data.attributes.createdAt"], DateTransform())
        duration <- map["data.attributes.duration"]
        gameMode <- map["data.attributes.gameMode"]
        patchVersion <- map["data.attributes.patchVersion"]
        endGameReason <- map["data.attributes.stats.endGameReason"]
        queue <- map["data.attributes.stats.queue"]
        shard = Shard(rawValue: map["data.attributes.shardId"].currentValue as? String ?? "na")
        
        let mappedRostersRelationships = map["data.relationships.rosters.data"].currentValue as? [[String: String]]
        mappedRostersRelationships?.forEach { element in
            if let id = element["id"] {
                rostersRelationships.append(id)
            }
        }
        
        let included = map["included"].currentValue as? [[String: Any]] ?? []
        
        var players: [PlayerResponseModel] = []
        var participants: [ParticipantResponseModel] = []
        
        included.forEach { json in
            let id = json["id"] as? String
            let entityType: Entities = Entities(rawValue: json["type"] as? String ?? "unknown") ?? .unknown
            
            switch entityType {
            case .player:
                if let player = PlayerResponseModel(JSON: json) {
                    players.append(player)
                }
            case .participant:
                if let participant = ParticipantResponseModel(JSON: json) {
                    participants.append(participant)
                }
            case .roster:
                if let roster = RosterResponseModel(JSON: json) {
                    rosters.append(roster)
                }
            default:
                // Ignore
                break
            }
        }
        
        players.forEach { player in
            participants.forEach { participant in
                if let id = player.id, participant.playerRelationship == id {
                    participant.player = player
                }
            }
        }
        
        participants.forEach { participant in
            rosters.forEach { roster in
                if let id = participant.id, roster.participantsRelationships.contains(id) {
                    roster.participants.append(participant)
                }
            }
        }
    }
}

class RosterResponseModel: Mappable {
    var id: String?
    var acesEarned: Int?
    var gold: Int?
    var heroKills: Int?
    var krakenCaptures: Int?
    var side: String?
    var turretKills: Int?
    var turretsRemaining: Int?
    
    var participants: [ParticipantResponseModel] = []

    var participantsRelationships: [String] = []

    var description: String {
        return "[RosterResponseModel] id: \(id)"
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        acesEarned <- map["attributes.stats.acesEarned"]
        gold <- map["attributes.stats.gold"]
        heroKills <- map["attributes.stats.heroKills"]
        krakenCaptures <- map["attributes.stats.krakenCaptures"]
        side <- map["attributes.stats.side"]
        turretKills <- map["attributes.stats.turretKills"]
        turretsRemaining <- map["attributes.stats.turretsRemaining"]
        
        let mappedParticipantsRelationships = map["relationships.participants.data"].currentValue as? [[String: String]]
        mappedParticipantsRelationships?.forEach { element in
            if let id = element["id"] {
                participantsRelationships.append(id)
            }
        }
    }
}

class ParticipantResponseModel: Mappable {
    var id: String?
    var actor: String?
    var assists: Int?
    var crystalMineCaptures: Int?
    var deaths: Int?
    var farm: Int?
    var firstAfkTime: String?
    var goldMineCaptures: Int?
    var itemGrants: [String: Int]?
    var itemSells: [String: Int]?
    var itemUses: [String: Int]?
    var items: [String]?
    var jungleKills: Int?
    var karmaLevel: Int?
    var kills: Int?
    var krakenCaptures: Int?
    var level: Int?
    var minionKills: Int?
    var nonJungleMinionKills: Int?
    var skillTier: Int?
    var skinKey: String?
    var turretCaptures: Int?
    var wentAfk: Bool?
    var winner: Bool?

    var player: PlayerResponseModel?
    var playerRelationship: String?
    
    var description: String {
        return "[ParticipantResponseModel]"
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        actor <- map["attributes.actor"]
        assists <- map["attributes.stats.assists"]
        crystalMineCaptures <- map["attributes.stats.crystalMineCaptures"]
        deaths <- map["attributes.stats.deaths"]
        farm <- map["attributes.stats.farm"]
        firstAfkTime <- map["attributes.stats.firstAfkTime"]
        goldMineCaptures <- map["attributes.stats.goldMineCaptures"]
        itemGrants <- map["attributes.stats.itemGrants"]
        itemSells <- map["attributes.stats.itemSells"]
        itemUses <- map["attributes.stats.itemUses"]
        items <- map["attributes.stats.items"]
        jungleKills <- map["attributes.stats.jungleKills"]
        karmaLevel <- map["attributes.stats.karmaLevel"]
        kills <- map["attributes.stats.kills"]
        krakenCaptures <- map["attributes.stats.krakenCaptures"]
        level <- map["attributes.stats.level"]
        minionKills <- map["attributes.stats.minionKills"]
        nonJungleMinionKills <- map["attributes.stats.nonJungleMinionKills"]
        skillTier <- map["attributes.stats.skillTier"]
        skinKey <- map["attributes.stats.skinKey"]
        turretCaptures <- map["attributes.stats.turretCaptures"]
        wentAfk <- map["attributes.stats.wentAfk"]
        winner <- map["attributes.stats.winner"]

        if let id = map["relationships.player.data.id"].currentValue as? String {
            playerRelationship = id
        }
    }
}

class TeamResponseModel: Mappable {
    var id: String?
    
    var description: String {
        return "[TeamResponseModel]"
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
    }
}
