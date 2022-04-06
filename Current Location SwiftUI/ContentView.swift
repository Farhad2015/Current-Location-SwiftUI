//
//  ContentView.swift
//  Current Location SwiftUI
//
//  Created by Mahmudur Rahman on 6/4/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    
    
    var body: some View {
        ZStack {
            VStack {
                Text("location status: \(locationManager.statusString)")
                HStack {
                    Text("latitude: \(userLatitude)")
                    Text("longitude: \(userLongitude)")
                }
                
                Text("Address: ")
                    .padding(.top, 30)
                
            }.onChange(of: userLatitude) { newValue in
                print("Latitude: \(userLatitude)")
                print("Longitude: \(userLongitude)")
                let location = CLLocation(latitude: locationManager.lastLocation?.coordinate.latitude ?? 0.0, longitude: locationManager.lastLocation?.coordinate.longitude ?? 0.0)
                CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in

                    guard let placemark = placemarks?.first else {
                        let errorString = error?.localizedDescription ?? "Unexpected Error"
                        print("Unable to reverse geocode the given location. Error: \(errorString)")
                        return
                    }

                    let reversedGeoLocation = ReversedGeoLocation(with: placemark)
                    print(reversedGeoLocation.formattedAddress)
                    print("name is: \(reversedGeoLocation.name)")
                    print("streetName is: \(reversedGeoLocation.streetName)")
                    print("streetNumber is: \(reversedGeoLocation.streetNumber)")
                    print("city is: \(reversedGeoLocation.city)")
                    print("state is: \(reversedGeoLocation.state)")
                    print("zipCode is: \(reversedGeoLocation.zipCode)")
                    print("country is: \(reversedGeoLocation.country)")
                    print("isoCountryCode is: \(reversedGeoLocation.isoCountryCode)")
                    // Apple Inc.,
                    // 1 Infinite Loop,
                    // Cupertino, CA 95014
                    // United States
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
