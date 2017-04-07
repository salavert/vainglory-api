//
//  SampleResource.swift
//  Pods
//
//  Created by Jose Salavert on 07/04/2017.
//
//

import Alamofire
import Foundation
import Mapper
import Treasure
import Zip

public struct SampleResource: Resource {
    
    public let id: String
    public let type: String
    
    public let url: String?
    public let createdAt: String?
    public let shardId: String?
    public let titleId: String?
    public let t0: String?
    public let t1: String?
    
    public init(map: Mapper) throws {
        id = try map.from(Key.id)
        type = try map.from(Key.type)
        
        url = try map.from(Key.attributes("URL"))
        createdAt = try map.from(Key.attributes("createdAt"))
        shardId = try map.from(Key.attributes("shardId"))
        titleId = try map.from(Key.attributes("titleId"))
        t0 = try map.from(Key.attributes("t0"))
        t1 = try map.from(Key.attributes("t1"))
    }
}

public extension SampleResource {
    public func getMatches(completionHandler: @escaping ([MatchResource]?) -> Void, progressHandler: ( (Progress) -> Void)? = nil) {
        guard let url = url, let requestUrl = URL(string: url) else {
            completionHandler(nil)
            return
        }
        var matches = [MatchResource]()
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
            
        Alamofire.download(requestUrl, to: destination)
            .downloadProgress { progress in
                progressHandler?(progress)
            }
            .responseData { response in
            guard let destinationUrl = response.destinationURL else {
                completionHandler(nil)
                return
            }
            guard let path = try? Zip.quickUnzipFile(destinationUrl).relativePath else {
                completionHandler(nil)
                return
            }
            guard let enumerator = FileManager.default.enumerator(atPath: path) else {
                completionHandler(nil)
                return
            }
            FileManager.default.changeCurrentDirectoryPath(path)
            while let file = enumerator.nextObject() as? String {
                if file.hasSuffix("json") {
                    guard let data = try? Data(contentsOf: URL(fileURLWithPath: file)) else {
                        completionHandler(nil)
                        return
                    }
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as! Parameters else {
                        completionHandler(nil)
                        return
                    }
                    if let match: MatchResource = Treasure(json: json).map() {
                        matches.append(match)
                    }
                }
            }
            completionHandler(matches)
        }
    }
}
