


//  Navigation
//
//  Created by Genesis Muñoz on 3/28/21.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation
import SwiftUI


//to display all bins in map
struct totBins{
    var name: String
    var lattitude: CLLocationDegrees
    var longitude:CLLocationDegrees

}


class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(pinTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.coordinate = location
    }
}


class ViewController: UIViewController{

    //making some outlets
    @IBOutlet weak var directionsLabel: UILabel!
    //@IBOutlet weak var searchbar:UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func didTapNB(_ sender: Any) {
        print("button is reacting")
        if goingToAnotherBin{
            bincounter += 1
            if bincounter == 2 {
                self.getDirections(from: firstBin, to: secondBin)
                print(bincounter)
            }
            if bincounter == 3 {
                
                self.getDirections(from: secondBin, to: thirdBin)
                print(bincounter)
            }
            if bincounter == 4 {
                self.getDirections(from: thirdBin, to: fourthBin)
                print(bincounter)
            }
            if bincounter == 5 {
                self.getDirections(from: fourthBin, to: baselocation)
                print(bincounter)
            }
            if bincounter == 6 {
                goingToAnotherBin = false
            }
            
        }
        
    }
    
    
    
    //location manager
    var goingToAnotherBin = true
    var bttnPressed: Bool!
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D!
    var stepsinroute = [MKRoute.Step]()
    let speechSynth = AVSpeechSynthesizer()
    var nameofroute :String!
    var directionSteps = 0
    var bincounter = 0
    var inSF = false
    
    //SET BIN LOCATIONS INCLUDING OUR STARTING POINT AND A BASE LOCATION FOR AFTER BINS ARE SERVICED
    var startingLocation = CLLocationCoordinate2D(latitude: 37.787371, longitude: -122.408238)
    var baselocation = CLLocationCoordinate2D(latitude: 37.787371, longitude: -122.408238)
    var firstBin = CLLocationCoordinate2D(latitude: 37.78797, longitude: -122.40770)
    var secondBin = CLLocationCoordinate2D(latitude: 37.78913, longitude: -122.40147)
    var thirdBin = CLLocationCoordinate2D(latitude: 37.79411, longitude: -122.39905)
    var fourthBin = CLLocationCoordinate2D(latitude: 37.78982, longitude: -122.40834)




    //SET LOCATIONS FOR BINS


    override func viewDidLoad() {
        super.viewDidLoad()


        setStartingPosition()
        let binss = getBinLocation()
        setAnnotation(bins: binss)

        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
               // present an alert indicating location authorization required
               // and offer to take the user to Settings for the app via
               // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
               locationManager.requestAlwaysAuthorization()
               locationManager.requestWhenInUseAuthorization()
           }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()


        
        
        

    }

    func getDirections(from start: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        //SETTING PLACEMARK
        let sourcePlacemark = MKPlacemark(coordinate: start)
        let sourcedestination = MKPlacemark(coordinate: destination)

        // DIRECTIONS REQUEST
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionsRequest.destination = MKMapItem(placemark: sourcedestination)
        directionsRequest.transportType = .automobile//no bus option available

        // CALCULATE DIRECTIONS
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { (response, error) in
            if error != nil {
                print("error calculating route")
            }
            guard let response = response else {return}
            guard let primaryRoute = response.routes.first else {return}//only doing one route
            self.nameofroute = primaryRoute.name
            self.stepsinroute = primaryRoute.steps
            self.mapView.delegate = self
            self.mapView.userTrackingMode = .follow
            self.mapView.addOverlay(primaryRoute.polyline)
          
            self.locationManager.monitoredRegions.forEach({self.locationManager.stopMonitoring(for: $0)})
            for i in 0 ..< primaryRoute.steps.count{
                let step = primaryRoute.steps[i]
                print(step.instructions)
                print(step.distance)
                let region = CLCircularRegion(center: step.polyline.coordinate, radius: 20 , identifier: "bin \(i)")
                self.locationManager.startMonitoring(for: region)
                
                //display corners since blue line won't update
                let circle = MKCircle(center: region.center, radius: region.radius)
                self.mapView.addOverlay(circle)

            }

            //polyline make route show up and route details
            let directiongmsg = "In \(self.stepsinroute[0].distance.rounded()) meters, \(self.stepsinroute[0].instructions) then in \(self.stepsinroute[1].distance.rounded()) meters, \(self.stepsinroute[1].instructions)."


            //NARRATING INSTRUCTIONS
            self.directionsLabel.text = directiongmsg
            let speechUtter = AVSpeechUtterance(string: directiongmsg)
            self.speechSynth.speak(speechUtter)
            self.directionSteps += 1;
        }

    }
}

//extensions like core location

    extension ViewController: CLLocationManagerDelegate{//USERS LOCATION
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
            manager.stopUpdatingLocation()
            //want to get users coordinates and zoom in to where they are looking

            guard let currentLocation = locations.first else{return}
            currentCoordinate = currentLocation.coordinate

            //zoom into location
            mapView.userTrackingMode = .followWithHeading

        }

    //////////////////// DIRECTION DISPLAY///////////////////////
    //need to monitor steps taken for directions
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("ENTERED")
        directionSteps += 1
        //bincounter += 1
        if directionSteps < stepsinroute.count{//if we are out of range we fail
            let currentstep = stepsinroute[directionSteps]
            let lastdirmessage = "In \(currentstep.distance.rounded()) meters, \(currentstep.instructions)"
            sleep(4)
            directionsLabel.text = lastdirmessage
            let speechUtterance = AVSpeechUtterance(string: lastdirmessage)
            speechSynth.speak(speechUtterance)

        }else{//no steps left to go
            if bincounter == 5 {
                let message = "Back in Base Station"
                directionsLabel.text = message
                directionsLabel.backgroundColor = .green
                let speechUtterance = AVSpeechUtterance(string: message)
                sleep(1)
                speechSynth.speak(speechUtterance)
            }
            let message = "You have serviced this Bin"
            directionsLabel.text = message
            directionsLabel.backgroundColor = .green
            let speechUtterance = AVSpeechUtterance(string: message)
            sleep(1)
            speechSynth.speak(speechUtterance)

            //reset after arrival
            directionSteps = 0
            locationManager.monitoredRegions.forEach({self.locationManager.stopMonitoring(for: $0)})//stop monitoring at that index

        }
    }



    func setStartingPosition(){
        if(bincounter==2){
            startingLocation.self = firstBin.self
        }
        if(bincounter==3){
            startingLocation.self = secondBin.self
        }
        let position = MKCoordinateRegion(center: startingLocation.self, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(position, animated: true)
            
        //begin mapping to the first bin
        getDirections(from: startingLocation, to: firstBin)
        bincounter += 1 //1 for gone to bin 1
    }

    func getBinLocation() -> [totBins]{//initializing map pins to display bins
        return[
            totBins(name: "Bin 2", lattitude: 37.78797, longitude: -122.40770),
            totBins(name: "Bin 4", lattitude: 37.78913, longitude: -122.40147),
            totBins(name: "Bin 5", lattitude: 37.79411, longitude: -122.39905),
            totBins(name: "Bin 7", lattitude: 37.78982, longitude: -122.40834)

        ]
    }

    func setAnnotation(bins:[totBins]){
        for i in bins{
            let annotation = MKPointAnnotation()
            annotation.title = i.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: i.lattitude, longitude: i.longitude )
            mapView.addAnnotation(annotation)
        }
    }
        
}
extension ViewController: MKMapViewDelegate{//for displaying route
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay)->MKOverlayRenderer{ //SHOWS THE ROUTE!!!!
        if let overlay = overlay as? MKPolyline{
            print("here in MKPolyline")
            let renderer = MKPolylineRenderer(polyline: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 10
            return renderer
        }
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.fillColor = .blue
            renderer.alpha = 0.2
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

