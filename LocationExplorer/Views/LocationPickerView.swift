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
    @EnvironmentObject var locationManager:LocationService
    
    @State private var interestingLocation:LSLocation = LocationStore.locations[0]
    @State private var searchField:String = ""
    
    @State private var searchResult:MKMapItem = LocationStore.locations[0].asMapItem()
    
    @StateObject private var searchService = LocationSearchService()
    
    
    var body: some View {
        Form {

//            Section("Root Location") {
//                Text("Your location: \(locationManager.locationToUse.latitude), \(locationManager.locationToUse.longitude)")
//                Text("Place Name: \(locationManager.locationToUse.description)")
//                //Text("Locality name: \(locationManager.locality ?? "...")")
//
//
//            }
//            Section("Physical Location") {
//                HStack {
//                    //TextField("Location", text: $locationName)
//                    CurrentLocationButton()
//                }
//            }
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
                HStack {
                    LocationPicker(mapitem: $searchResult)
                    //TODO: BAD NEWS spawning a hidden task call. 
                    CurrentLocationButton()
                }
                Button("Make Selected") {
                    newLocation(from: searchResult)
                }
                
                LocationPicker(mapitem: $searchResult).locationPickerStyle(.inlineSearch)
            }
        }
        
        .environmentObject(locationManager)
        .onReceive(locationManager.locationPublisher) { location in
            searchResult = location.asMapItem()
        }
    }

    
    func newLocation(from location:LSLocation) {
        locationManager.updateLocation(location)
    }
    
    func newLocation(from location:MKMapItem) {
        print("enter newLocation")
        if let asLocation = LSLocation(from: location) {
            print("got Location")
            Task { locationManager.updateLocation(asLocation) }
            print("updating Location")
        } else {
            print("Something didn't work.")
        }
    }
    
    func runSearch() {
        searchService.runKeywordSearch(for: searchField)
    }
    
}

//TODO: BAD NEWS spawning a hidden task call. 
struct CurrentLocationButton: View {
    @EnvironmentObject var locationManager:LocationService
    
    @State var updateTask:Task<(),Never>?
    
    
    var body: some View {
        if #available(iOS 15.0, *) {
            LocationButton(.currentLocation) {
                if updateTask == nil {
                    print("new request task")
                    //TODO: Move this task spawning back into the View??
                    updateTask = locationManager.startDeviceLocationUpdateAttempt()
                } else {
                    print("attempt to clean up task")
                    if locationManager.status != .pending {
                        updateTask?.cancel()
                        print("updateTask: \(String(describing: updateTask))")
                        updateTask = nil
                    } else {
                        print("still working")
                    }
                }
            }.symbolVariant(.fill)
                .labelStyle(.iconOnly)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .font(.system(size:12))
                .onDisappear() {
                    updateTask?.cancel()
                }
                .onReceive(locationManager.$locationToUse) { _ in
                    if (updateTask != nil) {
                        updateTask?.cancel()
                        updateTask = nil
                        print("changed detected. canceling task. ")
                    }
                }
        }
    }
    
    
}


struct LocationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        LocationPickerView().environmentObject(LocationService(locationStore: LocationStore(), deviceLocationManager: DeviceLocationManager()))
    }
}
