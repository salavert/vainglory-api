//
//  RosterResource.swift
//  Pods
//
//  Created by Jose Salavert on 26/03/2017.
//
//

import Foundation
import Mapper
import Treasure

struct RosterResource: Resource {

    let id: String
    let type: String
    
    let acesEarned: Int?
    let gold: Int?
    let heroKills: Int?
    let krakenCaptures: Int?
    let side: String?
    let turretKills: Int?
    let turretsRemaining: Int?

    let participants: [ParticipantResource]?
    
    init(map: Mapper) throws {
        id = try map.from(Key.id)
        type = try map.from(Key.type)
        
        acesEarned = try? map.from(Key.attributes("stats.acesEarned"))
        gold = try? map.from(Key.attributes("stats.gold"))
        heroKills = try? map.from(Key.attributes("stats.heroKills"))
        krakenCaptures = try? map.from(Key.attributes("stats.krakenCaptures"))
        side = try? map.from(Key.attributes("stats.side"))
        turretKills = try? map.from(Key.attributes("stats.turretKills"))
        turretsRemaining = try? map.from(Key.attributes("stats.turretsRemaining"))
        
        let participantsRelationship: ToManyRelationship? = try? map.from(Key.relationships("participants"))
        participants = try? map.from(participantsRelationship)
    }
}
