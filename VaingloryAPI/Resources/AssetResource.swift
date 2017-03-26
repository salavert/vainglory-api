//
//  AssetResource.swift
//  Pods
//
//  Created by Jose Salavert on 26/03/2017.
//
//

import Foundation
import Mapper
import Treasure

public struct AssetResource: Resource {
    
    public let id: String
    public let type: String
    
    let url: String?
    let contentType: String?
    let createdAt: String?
    let description: String?
    let filename: String?
    let name: String?
    
    public init(map: Mapper) throws {
        id = try map.from(Key.id)
        type = try map.from(Key.type)
        
        url = try? map.from(Key.attributes("URL"))
        contentType = try? map.from(Key.attributes("contentType"))
        createdAt = try? map.from(Key.attributes("createdAt"))
        description = try? map.from(Key.attributes("description"))
        filename = try? map.from(Key.attributes("filename"))
        name = try? map.from(Key.attributes("name"))
    }
}
