# Vainglory API in swift
[![CocoaPods](https://img.shields.io/cocoapods/v/VaingloryAPI.svg)](https://cocoapods.org/pods/VaingloryAPI) 
[![Build Status](https://travis-ci.org/salavert/vainglory-api.svg?branch=master)](https://travis-ci.org/salavert/vainglory-api)
[![CocoaPods](https://img.shields.io/cocoapods/l/VaingloryAPI.svg)]()

## Installation

#### With [CocoaPods](http://cocoapods.org/)

```ruby
use_frameworks!

pod 'VaingloryAPI'
```

## Usage

Request a [Vainglory API key](https://developer.vainglorygame.com)

### Getting players

```swift
import VaingloryAPI

let vaingloryAPI = VaingloryAPIClient(apiKey: "YOUR_VAINGLORY_API_KEY")

// Retrieving a player by Id
vaingloryAPI.getPlayer(withId: "b7ce178c-bd4b-11e4-8883-06d90c28bf1a", shard: .eu) { player, error in
    print(player)
}

// Retrieving a player by name
vaingloryAPI.getPlayer(withName: "Salavert", shard: .eu) { player, error in
    print(player)
}
```

### Getting matches

```swift
// Retrieving match by Id
vaingloryAPI.getMatch(withId: "c481c96a-03fd-11e7-8f17-0266696addef", shard: .eu) { match, error in
    // Getting match rosters
    print(match.rosters)
    
    // Getting participants of first roster
    print(match.rosters?.first?.participants)

    // Getting first player of first rosters
    print(match.rosters?.first?.participants?.first?.player)
}

// Retrieving matches based on player names
let filters = RouterFilters()
    .playerNames(["Salavert", "PlayerName2"])
    .createdAtStart("2017-01-20T11:47:42Z")
    .limit(10)
        
vaingloryAPI.getMatches(shard: .eu, filters: filters) { matches, error in
    print(matches)
}
```

### Samples

A sample contains a collection of random matches

Retrieving matches of latest available sample
```swift
vaingloryAPI.getSampleMatches(shard: .na) { matches, error in
    if let matches = matches {
        print(matches)
    } else if let error = error {
        print(error)
    }
}
```

If you prefer to do it manually and have feedback of download progress

```swift
let filters = RouterFilters().limit(1)
        
vaingloryAPI.getSamples(shard: .na, filters: filters) { samples, error in
    if let samples = samples {
        samples.first?.getMatches(
            completionHandler: { matches in
                if let matches = matches {
                    print("Matches count: \(matches.count)")
                }
        },
            progressHandler: { progress in
                print("Download Progress: \(progress.fractionCompleted)")
        })
    } else if let error = error {
        print(error)
    }
}
```

### Telemetry

```swift
let url = "https://gl-prod-us-east-1.s3.amazonaws.com/assets/semc-vainglory/na/2017/03/17/00/43/b900c179-0aaa-11e7-bb12-0242ac110005-telemetry.json"
vaingloryAPI.getTelemetry(url: url) { telemetryList, error in
    print(telemetryList?.count)
}
```

## Features:

* Player by id or name.
* Match by id.
* List of matches based on filters.
* Telemetry