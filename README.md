# Vainglory API in swift

This API is under development, not production ready.

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
    
    // Getting participant of first rosters
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