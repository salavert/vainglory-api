//
//  TelemetryResource.swift
//  Pods
//
//  Created by Jose Salavert on 29/03/2017.
//
//

import Foundation
import ObjectMapper

public enum TelemetryType: String {
    case Unknown
    case PlayerFirstSpawn
    case LevelUp
    case BuyItem
    case SellItem
    case LearnAbility
    case UseAbility
    case KillActor
    case EarnXP
    case DealDamage
    case GoldFromTowerKill
    case GoldFromGoldMine
}

public class TelemetryResource: StaticMappable {
    public var type: TelemetryType = .Unknown
    public var time: String?
    public var actor: String?
    public var team: String?
    
    public class func objectForMapping(map: Map) -> BaseMappable? {
        if let typeString: String = map["type"].value() {
            let type = TelemetryType(rawValue: typeString) ?? .Unknown
            
            switch type {
            case .PlayerFirstSpawn:
                return PlayerFirstSpawnTelemetryResource()
            case .LevelUp:
                return LevelUpTelemetryResource()
            case .BuyItem:
                return BuyItemTelemetryResource()
            case .SellItem:
                return SellItemTelemetryResource()
            case .LearnAbility:
                return LearnAbilityTelemetryResource()
            case .UseAbility:
                return UseAbilityTelemetryResource()
            case .KillActor:
                return KillActorTelemetryResource()
            case .EarnXP:
                return EarnXPTelemetryResource()
            case .DealDamage:
                return DealDamageTelemetryResource()
            case .GoldFromTowerKill:
                return GoldFromTowerKillTelemetryResource()
            case .GoldFromGoldMine:
                return GoldFromGoldMineTelemetryResource()
            default:
                print("Unknown telemetry type: \(typeString)")
                return nil
            }
        }
        return nil
    }
    
    public init(){
        
    }
    
    public func mapping(map: Map) {
        type <- map["type"]
        time <- map["time"]
        actor <- map["payload.Actor"]
        team <- map["payload.Team"]
    }
}

public class PlayerFirstSpawnTelemetryResource: TelemetryResource {
    override public class func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
    }
}

public class LevelUpTelemetryResource: TelemetryResource {
    public var level: Int?
    public var lifetimeGold: Int64?
    
    override public class func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        level <- map["payload.Level"]
        lifetimeGold <- map["payload.LifetimeGold"]
    }
}

public class BuyItemTelemetryResource: TelemetryResource {
    public var cost: Int?
    public var item: String?
    
    override public class func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        cost <- map["payload.Cost"]
        item <- map["payload.Item"]
    }
}

public class SellItemTelemetryResource: BuyItemTelemetryResource {
}

public class LearnAbilityTelemetryResource: TelemetryResource {
    public var ability: String?
    public var level: String?
    
    override public class func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        ability <- map["payload.Ability"]
        level <- map["payload.Level"]
    }
}

public class UseAbilityTelemetryResource: TelemetryResource {
    public var ability: String?
    public var position: [Double]?
    
    override public class func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        ability <- map["payload.Ability"]
        position <- map["payload.Position"]
    }
}

public class KillActorTelemetryResource: TelemetryResource {
    public var gold: Int?
    public var isHero = false
    public var killed: String?
    public var killedTeam: String?
    public var position: [Double]?
    public var targetIsHero = false
    
    override public class func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        gold <- map["payload.Gold"]
        isHero <- map["payload.IsHero"]
        killed <- map["payload.Killed"]
        killedTeam <- map["payload.KilledTeam"]
        position <- map["payload.Position"]
        targetIsHero <- map["payload.TargetIsHero"]
    }
}

public class EarnXPTelemetryResource: TelemetryResource {
    public var amount: Int?
    public var source: String?
    public var isShared = false
    
    override public class func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        amount <- map["payload.Amount"]
        source <- map["payload.Source"]
        isShared <- map["payload.Shared With"]
    }
}

public class DealDamageTelemetryResource: TelemetryResource {
    public var damage: Int?
    public var delt = false
    public var isHero = false
    public var source: String?
    public var target: String?
    public var targetIsHero = false
    
    override public class func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        damage <- map["payload.Damage"]
        delt <- map["payload.Delt"]
        isHero <- map["payload.IsHero"]
        source <- map["payload.Source"]
        target <- map["payload.Target"]
        targetIsHero <- map["payload.TargetIsHero"]
        
    }
}

public class GoldFromTowerKillTelemetryResource: TelemetryResource {
    public var amount: Int?
    
    override public class func objectForMapping(map: Map) -> BaseMappable? {
        return nil
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        amount <- map["payload.Amount"]
    }
}


public class GoldFromGoldMineTelemetryResource: GoldFromTowerKillTelemetryResource {
    
}

