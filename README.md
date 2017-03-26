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
            
vaingloryAPI.getPlayer(withId: "b7ce178c-bd4b-11e4-8883-06d90c28bf1a", shard: .eu) { player, error in
    print(player)
}
```

## Features:

* Retrieves Matches with its 2 rosters, 6 participants and players. Filters not configurable yet.
* Retrieves a Match by id
* Retrieves a Player by id or name