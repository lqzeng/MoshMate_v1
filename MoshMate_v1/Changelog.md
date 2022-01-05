#  Changelog

### v1

03/01/22
 
Added LocationViewModel which contains logic for MapKit authorising User Location services.
Added LocationView which holds the MapView of users location

Added FindViewModel which currently holds the distance from location 1 to location 2
Added FindView which is just the generic screen to display distance from location 1 to location 2

04/01/22

Implemented functions to calculate distance 
Implemented function to calculate angle between north and target
Deleted FindViewModel as changes are implemented in LocationViewModel

- Refactor location manager to its own class
- Need to figure out how to broadcast currentLocation 


# Required features

UI
Distance to user is shown as a number with a 360 degree style compass (see forerunner find my phone style) 

Backend
Connection between two users, where location 2 is the target user
- need to figure out how to share location with another user.
- need to pass in location 2 lat and long into the find view model
  


# Future features
Festivals can upload a map of their grounds which will be an overlay to the map.
Battery saving so location only sent once per minute
