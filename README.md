# Vainglory API in swift

This API is under development, not production ready.

## Installation

#### With [CocoaPods](http://cocoapods.org/)

```ruby
use_frameworks!

pod 'VaingloryAPI', :git => 'https://github.com/salavert/vainglory-api.git'
```

## Usage

Request a [Vainglory API key](https://developer.vainglorygame.com)

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

// Retrieving matches based on player names
let filters = RouterFilters()
    .playerNames(["Salavert", "PlayerName2"])
    .createdAtStart("2017-01-20T11:47:42Z")
    .limit(10)
        
vaingloryAPI.getMatches(shard: .eu, filters: filters) { matches, error in
    print(matches)
}
```

## Features:

* Retrieves Matches with its 2 rosters, 6 participants and players.
* Retrieves a Match by id.
* Retrieves a Player by id or name.