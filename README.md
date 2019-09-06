# githubsearcher

- Master detail project with MVC pattern created on Xcode 10.3 for now. I can't upgrade right now as I had other local projects using the same IDE
- Live search does not happen as of now. Search happens on click of Search button. 
  I was facing severe latency issues on the API when loading multiple details and images, so I limited the experience. 
- Table view shows only 30 results available from api search
- Cocoapods 
  - Alamofire for service calls
  - Kingfisher for image caching
- Reachability (Obj C with bridging header) for network check
- Basic auth used
- Alamofire beta looks latest - but I have used a previous stable version here - some service calls are suffering from threading and latency issues - multiple refreshes are required at times. I can explain this in detail with the code if required.
- Specific versions of Kingfisher and Alamofire are used to prevent pod install requirements - pods are checked in Github too to avoid install issues.
- Search text validation for only alphabets added for demonstration. 
