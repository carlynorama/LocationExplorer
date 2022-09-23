//
//  LocationPickerView.swift
//  PrototypleBuild
//
//  Created by Labtanza on 8/9/22.
//



import SwiftUI
import LocationServices
import CoreLocationUI
import MapKit


struct LocationPickerView: View {
    //@EnvironmentObject var weatherMap:WeatherVaneVM
    @EnvironmentObject var locationManager:LocationProvider
    
    @State private var locationName:String = ""
    @State private var interestingLocation:LSLocation = LocationStore.locations[0]
    @State private var searchField:String = ""
    
    @State private var searchResult:MKMapItem = LocationStore.locations[0].asMapItem()
    
    @StateObject private var searchService = LocationSearchService()
    
    
    var body: some View {
        Form {

            Section("Location Manager Location") {
                Text("Your location: \(locationManager.locationToUse.latitude), \(locationManager.locationToUse.longitude)")
                Text("Place Name: \(locationManager.locationToUse.description)")
                //Text("Locality name: \(locationManager.locality ?? "...")")
                
                
            }
            Section("Physical Location") {
                HStack {
                    TextField("Location", text: $locationName)
                    CurrentLocationButton()
                }
            }
            Section("Interesting Locations") {
                Picker("Interesting", selection: $interestingLocation) {
                    ForEach(LocationStore.locations, id: \.self) { option in
                        Text(option.description)
                    }
                }.onChange(of: interestingLocation, perform: { (value) in
                    newLocation(from: value)
                })
                
                
            }
            Section("Location Picker") {
                LocationPicker(mapitem: $searchResult)
                Button("Make Selected") {
                    newLocation(from: searchResult)
                }
            }
        }
        
        .environmentObject(locationManager)
    }

    
    func newLocation(from location:LSLocation) {
        locationManager.updateLocation(location)
    }
    
    func newLocation(from location:MKMapItem) {
        if let asLocation = LSLocation(from: location) {
            locationManager.updateLocation(asLocation)
        } else {
            print("Something didn't work.")
        }
    }
    
    func runSearch() {
        searchService.runKeywordSearch(for: searchField)
    }
    
}


struct CurrentLocationButton: View {
    @EnvironmentObject var locationManager:LocationProvider
    
    var body: some View {
        if #available(iOS 15.0, *) {
            LocationButton(.currentLocation) {
                Task { await locationManager.requestDeviceLocation() }
            }.symbolVariant(.fill)
                .labelStyle(.iconOnly)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .font(.system(size:12))
        }
    }
}


struct LocationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        LocationPickerView().environmentObject(LocationProvider(locationStore: LocationStore(), deviceLocationManager: DeviceLocationManager()))
    }
}
