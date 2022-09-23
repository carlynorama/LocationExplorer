//
//  ContentView.swift
//  LocationExplorer
//
//  Created by Labtanza on 9/20/22.
//

import SwiftUI
import CoreLocationUI
import CoreLocation.CLLocation
import LocationServices

struct ContentView: View {
    @EnvironmentObject var locationManager:LocationProvider
    
    //@State var currentlocation:CLLocationCoordinate2D?

    var body: some View {
        VStack {
            Text("\(locationManager.locationToUse.description)")
            
            LocationButton {
                Task {
                    await locationManager.requestDeviceLocation()
                }
            }
            .frame(height: 44)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding()
            
            Button("clear") {
                locationManager.clearHistory()
            }
            
            List(Array(locationManager.recentLocations)) { item in
                Text(item.description)
            }
            
            LocationPickerView()
        }.environmentObject(locationManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(LocationProvider(locationStore: LocationStore(), deviceLocationManager: DeviceLocationManager()))
    }
}
