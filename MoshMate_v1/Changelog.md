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

05/01/22

Refactored code, Location Manager now its own class. Separate views. ViewModels not needed anymore.

- Figure out how to connect with another user and have their location broadcasted to you
- place pin to set target coordinates

06/01/22

branch feature/find-view-pin
Refactored mapview into a MapUIView
- need to figure out how to handle a logn press within the MapUIView so I can decode geolocation

07/01/22
added target pin
added environment object LocationInfo to have global vars between views
fixed region to be current location

08/01/22

pin dropped with long press, select pin and make that target location implemented.
problem with waitig for alert prompt to give name as this only runs after the handlePress func has been completed
? on tap ask if you want to save a location, give it a name and icon on map

09/01/22

remove passing in of variables to coordinator if not needed
not implementing name of pin just for now.

- Week of 10/01/22
Back at work 
Try and implement a new view where alert pops up and then function runs for annotations

13/01/22
Added alert text view which passes into annotation title
Added alert view which can remove or select annotation for find view
Added transition between tabs
Added arrow and haptic feedback

16/01/22
Added rudimentary scrolling from FindView to MapView


# Required features

UI
Distance to user is shown as a number with a 360 degree style compass (see forerunner find my phone style) 

Backend
Connection between two users, where location 2 is the target user
- need to figure out how to share location with another user.
- need to pass in location 2 lat and long into the find view model
- look up Cloudkit
https://www.youtube.com/watch?v=fTNPRhGGP-0
  


# Future features
Festivals can upload a map of their grounds which will be an overlay to the map.
Battery saving so location only sent once per minute
Broadcast which turns screen into beacon

improve animated scrolling between views:
https://www.youtube.com/watch?v=62u7s1Z3aSo

save location on map, and be able to name it eg. TENT
- long press still target location and will still control the arrow

Share markers with friends / markers are visible with people you share them with

Friend location is an annotation so can select them for findview

Logs need to be recorded somewhere
