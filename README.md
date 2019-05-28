# LocationManager

LocationManager allows a user to search for a location showing the initial return results in a table view and then on a map or for a user to request to see their current location on a map. 


## Objective

Create a location manager app that is fully unit tested.


## Solution

This is a simple app implementing Protocol Orientated Programming which allows users to search for a location or show their current location. Search results are displayed in a table view while the selected/current location is displayed on a map with a placemark indicator.

No third party frameworks have been used in the development of this project. 


## Features

- On app launch, we present a blank table view with a search bar at the top of the page and a segmented controller at the bottom.
- The segmented controller toggles between the search screen and the current location screen.
- A table view (for the search screen) and map view are contained within a stack view and the appropriate view is hidden depending on the selected index of the segmented controller.
- The search bar is hidden and the map expands to the top of the screen when the user selects "current location"
- The app is fully unit tested for the Location Manager (CoreLocation) 


## Author

Daniel Henshaw, danieljhenshaw@gmail.com
