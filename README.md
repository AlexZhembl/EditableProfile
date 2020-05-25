# EditableProfile
Hello, this is my coding challenge "Editable Profile"

## Setup
in root directory  
`pod install`  
 `cd server/ && sh server.sh`


## Servers
I used npm server from challenge description to fetch attributes and locations, so my urls are  
* http://localhost:8080/en/locations/cities.json
* http://localhost:8080/en/single_choice_attributes.json  
  For testing you can easily change it at  
`UserProfileAttributesAndLocationsFetcher.swift line:68 and line:72`

## Technologies I used
* MVP-R pattern chose as primary (Presenter called 'ViewModel' according to my current project habit, I know the difference =) )
* Support SOLID principles where it is possible
* Wrote clean and reusable code
* Provide some UI test for primary use case  (**WARNING:** ensure that I/O -> Keyboard -> Connect hardware keyboard is OFF)

* [Swinject](https://github.com/Swinject/Swinject) for DI
* [Nimble](https://github.com/Quick/Nimble) and [Quick](https://github.com/Quick/Quick) for tests
* [Alamofire](https://github.com/Alamofire/Alamofire) for http networking
* [Toast](https://github.com/scalessec/Toast-Swift) for quick showing alerts

# FYI
There are some comments in my code to show you what and why I chose in current situation.  
Tested at ios13.0 simulators: Iphone SE, Ipad Pro
