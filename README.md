# reddit-place-2022
Testing interaction with Reddit's r/place for 2022

Currently this tool is solely for downloading the current .png image state of r/place, as well as the image diffs received 
from Reddit as they come over the websocket

# Help Wanted
- Automatically fetching the Bearer Token, presumably via logging into Reddit on the user's behalf?
- Submitting or engaging with the Websocket/place in a more substantive way, such as for marking pixels automatically

# Installation
Install Go 1.18, clone this repo, and run `go build main.go` (builds executable) or `go run main.go`

# Usage
`go run main.go` or 

`go build main.go` followed by `./main` or `./main.exe`

Find your Reddit Bearer Token, and supply it via the `REDDIT_BEARER_TOKEN` environment variable.

This can be found by searching the Network tab of Google Chrome
when logged in to https://new.reddit.com/r/place, and searching for "Bearer" like so:

![](bearer.png)

Double-click the blacked-out value, and it should pop out on the right panel. Copy that value and use it to supply the 
required `REDDIT_BEARER_TOKEN` env variable.