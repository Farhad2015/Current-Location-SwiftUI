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
    
    @State private var name = ""
    @State private var streetName = ""
    @State private var streetNumber = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var country = ""
    @State private var isoCountryCode = ""
    
    var body: some View {
        ZStack {
            VStack {
                Text("location status: \(locationManager.statusString)")
                HStack {
                    Text("latitude: \(userLatitude)")
                    Text("longitude: \(userLongitude)")
                }
                
                Text("Address ").font(.title3).textCase(.uppercase)
                    .padding(.top, 30)
                
                HStack {
                    VStack(alignment: .leading,spacing: 8) {
                        Text("Name: \(self.name)").font(.caption)
                        Text("streetName: \(self.streetName)").font(.caption)
                        Text("streetNumber: \(self.streetNumber)").font(.caption)
                        Text("city: \(self.city)").font(.caption)
                        Text("state: \(self.state)").font(.caption)
                        Text("zipCode: \(self.zipCode)").font(.caption)
                        Text("country: \(self.country)").font(.caption)
                        Text("isoCountryCode: \(self.isoCountryCode)").font(.caption)
                    }
                    Spacer()
                }.padding()
                
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
                    
                    self.name = reversedGeoLocation.name
                    self.streetName = reversedGeoLocation.streetName
                    self.streetNumber = reversedGeoLocation.streetNumber
                    self.city = reversedGeoLocation.city
                    self.state = reversedGeoLocation.state
                    self.zipCode = reversedGeoLocation.zipCode
                    self.country = reversedGeoLocation.country
                    self.isoCountryCode = reversedGeoLocation.isoCountryCode
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
