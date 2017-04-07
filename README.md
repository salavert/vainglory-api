# Vainglory API in swift
[![CocoaPods](https://img.shields.io/cocoapods/v/VaingloryAPI.svg)](https://cocoapods.org/pods/VaingloryAPI) 
[![Build Status](https://travis-ci.org/salavert/vainglory-api.svg?branch=master)](https://travis-ci.org/salavert/vainglory-api)
[![CocoaPods](https://img.shields.io/cocoapods/l/VaingloryAPI.svg)]()

## Installation

#### With [CocoaPods](http://cocoapods.org/)

Open terminal and go to your project root folder, create a Podfile as follows

```bash
pod init
vi Podfile
```

Add pod to target, for example:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'MYPROJECT' do
    pod 'VaingloryAPI'
end
```

Now install it and open generated workspace

```bash
pod install
open MYPROJECT.xcworkspace
```

## Usage

Request a [Vainglory API key](https://developer.vainglorygame.com) and pass it to VainggloryAPI client

```swift
import VaingloryAPI

let vaingloryAPI = VaingloryAPIClient(apiKey: "YOUR_VAINGLORY_API_KEY")
```

## Getting players

### Player by id

```swift
vaingloryAPI.getPlayer(withId: "b7ce178c-bd4b-11e4-8883-06d90c28bf1a", shard: .eu) { player, error in
    if let player = player {
        print("[VaingloryAPI] \(player)")
    } else if let error = error {
        print("[VaingloryAPI] \(error)")
    }
}
```

### Player by name

```swift
vaingloryAPI.getPlayer(withName: "Salavert", shard: .eu) { player, error in
    if let player = player {
        print("[VaingloryAPI] \(player)")
    } else if let error = error {
        print("[VaingloryAPI] \(error)")
    }
}
```

### Players by name

```swift
vaingloryAPI.getPlayers(withNames: ["Salavert", "Facil"], shard: .eu) { players, error in
    if let players = players {
        for player in players {
            print("[VaingloryAPI] \(player)")
        }
    } else if let error = error {
        print("[VaingloryAPI] \(error)")
    }
}
```

## Getting matches

###  Match by Id

```swift
vaingloryAPI.getMatch(withId: "c481c96a-03fd-11e7-8f17-0266696addef", shard: .eu) { match, error in
    if let match = match {
        print("[VaingloryAPI] \(match)")
        // match.rosters
        // match.rosters?.first?.participants
        // match.rosters?.first?.participants?.first?.player
    } else if let error = error {
        print(error)
    }
}
```

###  Match by player name

```swift
let filters = RouterFilters()
    .playerName("Salavert")
    .limit(5)
                
vaingloryAPI.getMatches(shard: .eu, filters: filters) { matches, error in
    if let matches = matches {
        for match in matches {
            print("[VaingloryAPI] \(match)")
        }
    } else if let error = error {
        print("[VaingloryAPI] \(error)")
    }
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