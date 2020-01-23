# SmartPlantPot iOS App

This iOS app connects to the "SmartPlantPot" back end and shows you all the information you need about your plant. 

Key features include:

- a homepage with an overview of all your plants
- an extensive and interactive graphical representation of all the plant data you gathered with your Raspberry Pi
- history of all your plant data at the history tab or for a specific plant at its detail page
- support and display of a webcam image of your plant

## Important

Currently this app uses our specific API endpoint at trabby.at. You need to change this to your own API URLs. To do this, head to the class `Networkmanager.swift` and take a look at the `enum ApiEndpoints`:

- `homePage`: should be the URL to your API's plant/read php file
- `plantUpdate`: should be the URL to your API's plant/update_from_app php file
- `history`: should be the URL to your API's plant/read_by_plant_sorted php file

In case you need further information about the API, we suggest heading over to the API documentation at https://app.swaggerhub.com/apis-docs/Smart-Plant-Pot/SmartPlantPot/1.0.0

### Documentation

Check out the wiki page if you need more information or want to know more about our project: https://github.com/Snuu101/Smart-Plant-Pot.

### Software Versions

Xcode 11 / Swift 5 (master branch)

required iOS >= 13.0 

### Libraries Used

- [Charts](https://github.com/danielgindi/Charts)
- [Segmentio](https://github.com/Yalantis/Segmentio)
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [AlamofireImage](https://github.com/Alamofire/AlamofireImage)
- [Eureka](https://github.com/xmartlabs/Eureka)

### Acknowledgements

Icons made by Darius Dan and Freepik from www.flaticon.com
