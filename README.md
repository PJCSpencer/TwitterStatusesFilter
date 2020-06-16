
## Obtaining OAuth keys and tokens
Apply for a new Twitter developer account here: https://developer.twitter.com and once this has been approved create a new app here: https://developer.twitter.com/en/apps where a new set of keys and tokens can be created. Store in a safe place!

Further information can be found here: \
https://developer.twitter.com/en/docs/basics/apps/guides/the-app-management-dashboard

## Streaming live statuses
```swift
// Grab the keys and tokens.
let oauth = OAuthKeysAndTokens(apiKey: "<paste api key here>",
			       apiSecretKey: "<paste api secret key here>",
			       accessToken: "<paste access token here>",
			       accessTokenSecret: "<paste access token secret here>")
```
> Instantiate a new statuses filter
```swift		   
let api: PJCTweetSFRequestDelegate = PJCTweetStatusesFilter(oauth)
```
> Write a handler to accept new results
```swift
let handler: PJCTweetSFResponseHandler =
{ (result) in 
	
    if let tweet = try? result.get()
    { print("Tweet:\(tweet)") }
}
```
> Create a parameter track and let the good times roll
```swift
let items = ["nasa", "spacex"].compactMap({ PJCTweetSFTrackItem($0) })
let track = PJCTweetSFTrack(items: items)
let parameters = PJCTweetSFParameters(track)

api.request(parameters, 
	    completion: handler)
```
